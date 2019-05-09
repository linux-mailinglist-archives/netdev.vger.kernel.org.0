Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90E618AFD
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 15:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfEINwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 09:52:04 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43231 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfEINwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 09:52:04 -0400
Received: by mail-pg1-f193.google.com with SMTP id t22so1251690pgi.10
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 06:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MeO3R4Fb/XtCdvmPADMIAr/QN3Rz7kerjBP+VCKxOwM=;
        b=gip+xktoT8IWwvmDaVOpPcIyVNAhi3mPqp8gPEhl69KHTupKRZiPnVUbbzkwp0tUH2
         1bmE50XUoT6pUz1S6rvJBOOjSSGQlWs9m8hZ3TJfnL+uhyLjiWdUupPVbrvT+qGXeTZn
         PklgAaZoY9YK3xDmKQfgNjYrrm3gsvcU85bXm1ZHZj04+1zzoZGlLxqJObprU3YI8jSq
         eNYgSdzvEUoOIEZRxk/1aSLEpwS2u0kPJVpZW5RoHv5ZoquLNaA0M49ksi1X546wTWQF
         W5TRoBTwFAPsBAGTtIsxSPzk0YU6EGBlDC9UVjXWNy6rzxmlJW7YMNh760ByH+9x9U0C
         Kneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MeO3R4Fb/XtCdvmPADMIAr/QN3Rz7kerjBP+VCKxOwM=;
        b=YXwX0v64+r5q8+LwIfo+T8arT8LD9dTXi/UxMdMJse9BPaBS69s0xWWwh1ZW4vMNib
         bHAlgETmO7yqrRh+FveBFG0f1qB3qDHH559NWMkzmtdplLrG1VbEqOqGWWDD6hX0J0Wo
         r5+QPWJTeEP5HZRAtn42FhKwa1FwDD7xTtePuT+EAqeukTzXLJjbxmmZMw1g/1X4HneG
         rGX8+orwTtABdxOOQJYKh4GSSPZ2PBAdnduBMHFTz1hj52UJXkmjFxU80R134a+XGhGi
         JTQAwTLDAMPmo8SZFtaUi1+zA/0WsrzgbA6JjbKn28kzrZ+dRr8mWhDWCzJIZSOo2TH3
         lGdA==
X-Gm-Message-State: APjAAAXPfonYDdg1XxepEv9udHP8cus4HaCu/fu4XemxF4ZRoMBfJCbk
        zj99s62ofL1EjKWVP9GZ0JY=
X-Google-Smtp-Source: APXvYqzbk3SksEUCgi1CO3XBHhafTsi1N06eQWpm/E+SqfO4+fZFUHCYNsovQ/dTfku2XwRyFS8Bfg==
X-Received: by 2002:a63:1055:: with SMTP id 21mr5608231pgq.200.1557409924065;
        Thu, 09 May 2019 06:52:04 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id j1sm2585482pgp.91.2019.05.09.06.52.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 May 2019 06:52:03 -0700 (PDT)
Date:   Thu, 9 May 2019 06:52:01 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] macvlan: disable SIOCSHWTSTAMP in container
Message-ID: <20190509135201.esaftnkmdehlzp77@localhost>
References: <20190509065408.19444-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509065408.19444-1-liuhangbin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 02:54:08PM +0800, Hangbin Liu wrote:
> Miroslav pointed that with NET_ADMIN enabled in container, a normal user
> could be mapped to root and is able to change the real device's rx
> filter via ioctl on macvlan, which would affect the other ptp process on
> host. Fix it by disabling SIOCSHWTSTAMP in container.
> 
> Fixes: 254c0a2bfedb ("macvlan: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to real device")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
