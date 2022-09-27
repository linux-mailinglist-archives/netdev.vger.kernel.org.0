Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BEF5EC735
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbiI0PFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiI0PFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:05:31 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF8B81B39;
        Tue, 27 Sep 2022 08:05:27 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u59-20020a17090a51c100b00205d3c44162so2664308pjh.2;
        Tue, 27 Sep 2022 08:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=hXlpoPjXUYqfTCCTppdWcwW+T5QWKAe1Tf0ikgwGADk=;
        b=jfK2ySuvfYwd8+3MMkaECGS+wpBX9cWHQGhCg5yaefvd70jZLyoGR0SI9I0Ntvhzta
         M0J2UCZ+0zMQmIir28FnWWetEjgZ/H97tCSTV9Ut6SVAdbFJU2NYMRKOMmSHxiPxy2dZ
         v98oxpbsEc2SUdSbRdDHiUKl1nqgm4wYo7nQtWaauLYMA7YFbIQJ+fLGOc4VWa7tXKlj
         Q92GRBgF7k23kWcqNeBB13wtnzOE5JYRupPJx0h7dVppzM2C/It8EUG/5pAtcOCDHPSg
         qwgX4bxHdOmoc3nLsw/B9hTLmz0MLm/kUEGSUPXi5U2w2f4tATAZokrUHZcyf71K+A7K
         lgKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=hXlpoPjXUYqfTCCTppdWcwW+T5QWKAe1Tf0ikgwGADk=;
        b=JfqK/YAMkIgvsY4Nzhp+gh2dTqDnInInYMAu3GiQRUq2p9YfG94/InzoKOVU8b0iAV
         hTzIr2PCWaCwufuyYrOyTztO3zB0eKw7XTyU0ubgYhHuOS6a2k6f/5xSH+2ExRf7KDlC
         6Hh/xI+tYZjvhF3FQoRmzPRsohAl/J8X0TnuruygiZb/bp4VMmlREJk5GfIxdIqvgyKx
         Rsh+V7mdXPwOy0FlblxpUVMCMKj8UFizdZ899M7tX34vNmsJp64x3z4Mu6zp+k2CMRYO
         q3M4IWTkIalwsvfNw6L1Pwbm4p2qtNJlcC38Avc9BPHHVEaodAUCF9x3qbnturnoExlz
         vyXA==
X-Gm-Message-State: ACrzQf0cP/92Uo9TX195IhwI8sCxK3R5jeWJIzcirrdhon1aXHKceyoJ
        FHbheJWUCKnPYjpQBZxroXa0TtgIZv0=
X-Google-Smtp-Source: AMsMyM5YQCftWNQCyk4gFFZ6hujAj6M7wNKMPjFAWFba/hfqKYTovbONIUq/DF4swk0YWAi2detK1g==
X-Received: by 2002:a17:902:ed82:b0:178:5653:ecfb with SMTP id e2-20020a170902ed8200b001785653ecfbmr27670576plj.58.1664291126461;
        Tue, 27 Sep 2022 08:05:26 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id n5-20020aa79845000000b0053abb15b3d9sm1954237pfq.19.2022.09.27.08.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:05:25 -0700 (PDT)
Date:   Tue, 27 Sep 2022 08:05:23 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: Remove usage of the deprecated ida_simple_xxx API
Message-ID: <YzMRM0jwh+fauIWz@hoboy.vegasvil.org>
References: <20220926012744.3363-1-liubo03@inspur.com>
 <YzMQSJtLA1LDMGOm@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzMQSJtLA1LDMGOm@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 08:01:28AM -0700, Richard Cochran wrote:
> On Sun, Sep 25, 2022 at 09:27:44PM -0400, Bo Liu wrote:
> > Use ida_alloc_xxx()/ida_free() instead of
> > ida_simple_get()/ida_simple_remove().
> > The latter is deprecated and more verbose.
> 
> I can't say that I am excited about this.  It seems like a way to
> create a regression.  I don't see any need to change.  After all,
> there are many "deprecated" interfaces in use.

/git/linux$ git grep ida_simple_get | wc -l
119

~/git/linux$ git grep ida_simple_remove | wc -l
169

Please go take care of the other 100+ users of this API first, then
come bother me again.

Thanks,
Richard
