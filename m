Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865F017A237
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 10:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCEJ0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 04:26:45 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37288 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCEJ0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 04:26:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id 6so640190wre.4
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 01:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uCZg3dX3UvKPh3myfT9LoXgad0K8l/QztGsBeviabQ4=;
        b=vA6oznuXo1/nt1BWUhL4Smn4c06f/oPsa/46RFIxrv3aSqIowEiEg3u928TDNlvNAq
         a1AP1mn5KmxnR24vp+nDoEtfyVaOs0zYMWLaOo78yHgENhdLLhhS5em/UogLdrTar0v2
         W0bw3xVGeBHqv3gKYrCIJh/4gRUiZEk5A9vz0gwT9YLU5Ghe20wDTVEPc4EYKDzMJOIB
         uIKW7gEFvTN8Tly15qA2eGX5XiJCbStFByp9tx3DETjdZEFIhNgIX20xhf0e+Gb4jk1o
         bsDpFxX/3J9MWdvwQ76T6PulQba8N2gMWF+801VHeW8DntmQxCMD6Q6TDIPeCwfzkDmc
         k96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uCZg3dX3UvKPh3myfT9LoXgad0K8l/QztGsBeviabQ4=;
        b=pNGiOXVLWHyOnfmQ+f7Uvv65qK4Oy787T6u36D5zS1u1zX/UG6uAxpLqi4efuGHwKY
         kALndvAkd/pYhLv9iAY9XxkUQiSDVBL2tpdKS0TGNYLnisQoS4IOa3zBzrEWWPhVxt6c
         FzP3xJO+xkcpABOqHVtbslSL7iFhrJkAUjOz9F+xferjePijpx2hnQltqodaB7TnKiBM
         ny7mF+whwpT32VOCPr2tAdMrJjt+XFZDNCJecLIVym03HHtLv5uGk6l2XmOkEtgC2V0y
         ABgWUyXgbw3KiOe4kN9isnTT55AYIw23KGUM248HLceTB2FtxrSHY6vZ6Jcx/h2M58x8
         sQsA==
X-Gm-Message-State: ANhLgQ0VPhClHWtBBDfsi0GoVF/dO0kBlvi7HMWaJQGsFIrIg/P+P2K2
        YoYVm/MKmB0uxoKS4MFmmgopbA==
X-Google-Smtp-Source: ADFU+vuCUIQka6hIhfLr54gBYHw7uuMfUlmrFjg2W6JN9cXd2SRPJJ/68/eBgcAxOM/s5Mvq2SVPYg==
X-Received: by 2002:adf:fcc2:: with SMTP id f2mr9121354wrs.199.1583400403603;
        Thu, 05 Mar 2020 01:26:43 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id p15sm8179916wma.40.2020.03.05.01.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 01:26:43 -0800 (PST)
Date:   Thu, 5 Mar 2020 10:26:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, petrm@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/5] mlxsw: spectrum_qdisc: Add handle parameter
 to ..._ops.replace
Message-ID: <20200305092642.GC2190@nanopsycho>
References: <20200305071644.117264-1-idosch@idosch.org>
 <20200305071644.117264-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305071644.117264-4-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 05, 2020 at 08:16:42AM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>PRIO and ETS will need to check the value of qdisc handle in their
>handlers. Add it to the callback and propagate through.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
