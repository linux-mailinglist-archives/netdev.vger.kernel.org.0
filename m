Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAC01811C0
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 08:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgCKHT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 03:19:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37161 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgCKHT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 03:19:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id a141so879921wme.2
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 00:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Sj+Q0FXYLUB28UcOdYb15cqSESHfjSIpGDsJGxI33DM=;
        b=skMGr8WjVA4dNqLkGCS9uae7/AoyznI2UiYiFGpz9BS9BwwoAApM2JIw56bxboPbv7
         a1y+zOs3pm57VRLzgFUMS+bxMiI+dbxUCmaPTnugOvl7oriLdqjsMMhsQdaPg+lkbTC2
         9PEq1nQF4A9u+Oo09Y93KAKFVQoJN812nqQaFqcGZuixBAZtpe5BmkyGrNC/aPi60mt7
         eecKumFIqEPbPRhyOg2Tw5DkkKdz7/fMYWj4xflzG2NQrqBaa6o3TfAV1coISqHQVD7p
         Mbl+3dYVcm72T/Xaevi24wbu38y5RoPwnlMcxbHwuL3U5/3t0+jW0RSfm0p+vo4NDkqp
         BT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sj+Q0FXYLUB28UcOdYb15cqSESHfjSIpGDsJGxI33DM=;
        b=MhsDjce15MQXPgJ0sQox+7DkaU5B1K9zRMhGzVcBm92kKKyBK9YVK+32Yg3jkUgN9V
         /M88aQdrZsB5nuVqohxCDTDpg3okTkElYURjCzzCU0i8St6BLkYRpvzewYx6R89CFbwt
         LAM9NYzuBNVb3KPCJ22g2MIFjJgdoiKMJfzSS5cgM5rckadH4RSk+ThrvWySC2M1i1Ne
         oOgwlmOkF0DtD1//jUIh25470JYFYkXs5mZ8sjz0qZzB+bbcCZqOfWoVEbP6upThelgz
         Zj06sv8D8Zg9REatQGSRXJC91vc4QalhXzBUfSciUzGJiOFFLVkzFYhTPVviBAClNQWl
         HxBg==
X-Gm-Message-State: ANhLgQ2WTGhPCcD5Wwot9NRmqVGuK4W5dfygHUpOmb1hyIuG7Zzt2kEV
        Q66N9Jov6LcAOHd5+c8BZZIFmw==
X-Google-Smtp-Source: ADFU+vtEC5BbPBDK8EVIXfGXlozLcQ7ny85MWyvct7owheXneRN/rG98Ahe7XRE+u5N2w7x63YsiQA==
X-Received: by 2002:a1c:7901:: with SMTP id l1mr2110418wme.188.1583911196762;
        Wed, 11 Mar 2020 00:19:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p10sm5336021wru.4.2020.03.11.00.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 00:19:56 -0700 (PDT)
Date:   Wed, 11 Mar 2020 08:19:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: Re: [patch net-next 0/3] flow_offload: follow-ups to HW stats type
 patchset
Message-ID: <20200311071955.GA2258@nanopsycho.orion>
References: <20200310154909.3970-1-jiri@resnulli.us>
 <20200310120519.10bffbfe@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310120519.10bffbfe@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 10, 2020 at 08:05:19PM CET, kuba@kernel.org wrote:
>On Tue, 10 Mar 2020 16:49:06 +0100 Jiri Pirko wrote:
>> This patchset includes couple of patches in reaction to the discussions
>> to the original HW stats patchset. The first patch is a fix,
>> the other two patches are basically cosmetics.
>
>Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>
>This problem already exists, but writing a patch for nfp I noticed that
>there is no way for this:
>
>	if (!flow_action_hw_stats_types_check(flow_action, extack,
>					      FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT))
>		return -EOPNOTSUPP;
>
>to fit on a line for either bit, which kind of sucks.

Yeah, I was thinking about having flow_action_hw_stats_types_check as a
macro and then just simply have:

	if (!flow_action_hw_stats_types_check(flow_action, extack, DELAYED))
		return -EOPNOTSUPP;

WDYT?


>
>I may send a rename...
