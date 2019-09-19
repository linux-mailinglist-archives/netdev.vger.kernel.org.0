Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6CB1B741D
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 09:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388037AbfISHdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 03:33:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38946 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387987AbfISHdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 03:33:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id v17so2669557wml.4
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 00:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qHgNnRKppp7Nno+XhfV/vg8wXKHdm3+lSJQO2Vd0hsI=;
        b=llQsO+2dI7wLmrVoXfFo+AkKBv0rTH4ZrM5bHWiiysaj7LP7VutijQqIU6YDwWOs8I
         rdMGaN0ZpNvx6VNXOw2ycAK93nnbNqRZiEgy3ofUCH/Pr6jEGzUO7hUm6QheLqTqFjCx
         S431FBoQm8VNfTn8wmkIw+64Maaff7m/mObkQb0wgogDU4WBSsMyuS/jcYH3YCKKKbkc
         r/g9oivtH+zxr2ve/UYuwFRqULm62WtWnRJxUclok4n/UoTxqg827XQDrb28G6ESF6wu
         M1wCcMUSOHKk0PTpvk/3g8HsPwbHPbpdllTSEOwcOeoavpkQOw3LCyxAScM4ira+vnRh
         vRLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qHgNnRKppp7Nno+XhfV/vg8wXKHdm3+lSJQO2Vd0hsI=;
        b=RThQli/wipjwDbJKfCq5AhD0VfNcjZ305yENIT7+ppk3yWy4tB7GP7Be3kx0jHtq0B
         fiz8Ddj93VU7/ayOotm2HHMU9M/S1+QciXGg25HgbIl5jNKafqFQ8tpbW21VVT3CzhxH
         OSB9FGOPs+bONVTxMNRsm+flWoHGxyn4bsA7K5W7AZAOJ1ONCbcpALcDqsTKQQQ5qmcF
         3LUERMoozL7hYeJ6Xxsybg1If2hPnmLTAgtEvnIYlrVFp2wYXtPKRS6tJ1ALn+toIWus
         OUjGZapTKNys6kukdkRwaHPK2GiAjpNu64cR2f4ev992fMhK3GcpvRlPRAnCuZ9o5RX4
         zqnA==
X-Gm-Message-State: APjAAAXROihYbLEPkHpcXyi1Nt0+EB8ulZ9CAtzEriFJXRzaXG4vDiAP
        NLnQfl3FWOIAPYkVS9XU4BQuNg==
X-Google-Smtp-Source: APXvYqz1OhLjN6MxwCn6C3A6R+3dPAjwyQnY9PcpY2EcaF+YIUl568ZkPO5ItYsk9T7tvtVo5NRypw==
X-Received: by 2002:a7b:c758:: with SMTP id w24mr1402349wmk.148.1568878424885;
        Thu, 19 Sep 2019 00:33:44 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id v2sm9307567wmf.18.2019.09.19.00.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 00:33:44 -0700 (PDT)
Date:   Thu, 19 Sep 2019 09:33:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [Patch net] net_sched: add policy validation for action
 attributes
Message-ID: <20190919073343.GA2240@nanopsycho>
References: <20190919014443.32581-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919014443.32581-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 19, 2019 at 03:44:43AM CEST, xiyou.wangcong@gmail.com wrote:
>Similar to commit 8b4c3cdd9dd8
>("net: sched: Add policy validation for tc attributes"), we need
>to add proper policy validation for TC action attributes too.
>
>Cc: David Ahern <dsahern@gmail.com>
>Cc: Jamal Hadi Salim <jhs@mojatatu.com>
>Cc: Jiri Pirko <jiri@resnulli.us>
>Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
