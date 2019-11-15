Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75411FDF5F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 14:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfKONxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 08:53:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40725 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfKONxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 08:53:21 -0500
Received: by mail-wm1-f67.google.com with SMTP id f3so10484167wmc.5
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 05:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vnRMw3+UbZy0rA6oiz2O+xw7fSkKVfJNnex0oqybiDg=;
        b=gb7cRL+usJkOgacizdbIlxy1a/K79RO9bi29zNWgsmy0oE6Ptl9yfH7MqVQgUuRzoU
         Vi+5XaCkXzUUBZiRCOCjp22QbTD1KjeQH25lsCJEVDhZC/yJtyVWNHoKi8u6M92DZsDM
         CcuCy6EaM87gT3skHJFd8X7UX1i53cXbQPXaD4uxk7oe/S4Vw9I23k4wv548wnPMZ4F7
         5YpBxnzEb5ELTwrNy5yq+cXxMqd18ViQa8w1iaVCmswhPxyfc2ZTJenDMrq4m8EzBw1E
         txEzLHmO3aUF0EDlnLbTTOIQu2sw5cfHo27kWy7DDAjn/sMt+NegK2VvfcZG+1inOO0C
         qj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vnRMw3+UbZy0rA6oiz2O+xw7fSkKVfJNnex0oqybiDg=;
        b=LIrhaonQeGDgqna9nIEPBtvlL4ghwrKusNBrbG+FrjW03Mf2wz4bzQGBKdgXkjdFoc
         rSv0V8aJ2P/3KYRTUkahL+4IJmF8zKYxqTHhf/dgiKrQ46k6RpjYd/4xbwOLyWy5HOyQ
         rdwu8GZ+EeGExiP0JeVvlrgDfE/TT6c+vkC8xOyFeG+zPAtb1W339AaXLBFJrsp9E1z2
         wNL431c82OaGydFLYTWrQmE2Xeeb6eWDsVegLt3ehrhWrimwiZOs/auq8fUNJOgXbsk+
         ot+bkOAD7BgjWm1crqvlyyPxtvYRRb/XOV61ZryQWgchJVZEe6S8xIKVrO0a16y0Liqx
         lNlg==
X-Gm-Message-State: APjAAAVIWRyLiCvLFBZ3y5q94uIHBtSJkTQMcMl4vPMPpJjchUXwHSkL
        TTkjrr+yR8JPN33qn/ZrewJLnOpikTI=
X-Google-Smtp-Source: APXvYqzsqDm159D6tYBVD5PMfexBg3qW7RPBoz5mrdw3xRnMEVtpK6by/PzlZZ7ApebNYZ5sryk8hw==
X-Received: by 2002:a1c:2395:: with SMTP id j143mr14250463wmj.128.1573825999534;
        Fri, 15 Nov 2019 05:53:19 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id w4sm9319333wmi.39.2019.11.15.05.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 05:53:18 -0800 (PST)
Date:   Fri, 15 Nov 2019 14:53:18 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v3 2/2] cxgb4: add TC-MATCHALL classifier
 ingress offload
Message-ID: <20191115135318.GB2158@nanopsycho>
References: <cover.1573818408.git.rahul.lakkireddy@chelsio.com>
 <418c2bbf879fa75a8a3170d8523235f9b16af595.1573818409.git.rahul.lakkireddy@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <418c2bbf879fa75a8a3170d8523235f9b16af595.1573818409.git.rahul.lakkireddy@chelsio.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 15, 2019 at 01:14:21PM CET, rahul.lakkireddy@chelsio.com wrote:

[...]


>@@ -26,9 +37,13 @@ struct cxgb4_tc_matchall {
> };
> 
> int cxgb4_tc_matchall_replace(struct net_device *dev,
>-			      struct tc_cls_matchall_offload *cls_matchall);
>+			      struct tc_cls_matchall_offload *cls_matchall,
>+			      bool ingress);
> int cxgb4_tc_matchall_destroy(struct net_device *dev,
>-			      struct tc_cls_matchall_offload *cls_matchall);
>+			      struct tc_cls_matchall_offload *cls_matchall,
>+			      bool ingress);
>+int cxgb4_tc_matchall_stats(struct net_device *dev,
>+			    struct tc_cls_matchall_offload *cls_matchall);

Hmm, you only add stats function in this second patch. Does that mean
you don't care for stats in egress?
From looking at cxgb_setup_tc_matchall() looks like I'm right.
Why?

> 
> int cxgb4_init_tc_matchall(struct adapter *adap);
> void cxgb4_cleanup_tc_matchall(struct adapter *adap);
>-- 
>2.24.0
>
