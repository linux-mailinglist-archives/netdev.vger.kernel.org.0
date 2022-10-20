Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF916055D7
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 05:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiJTDQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 23:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiJTDQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 23:16:00 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F66149DEB
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 20:15:58 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f140so19074726pfa.1
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 20:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LAWpY3E6Odlf4ICMNyOR7W/BCVPWauSgjaNbb0CZ754=;
        b=ZUqUJ72dXjhcn/bj5k420ENm26GupZK5UWxDq+plYI2uuOR/tj7IBpkzQUbdwvd5Ai
         ckgHLIa0xBk7p3u9CSOGzRwcPvR+QQ8U4FYaMPBRGEp9NQ1/vibFChyBzLj6dDtBS0nJ
         1ds7d5CO7XpPCO086DIX48INxtRGYLgU3oGH9xjYv/Zgpo15w56NR5d3Y4uNVBanLYWz
         1vtieVGwgjyxKVJoQt1LOuOXBaiVdU9tFJUXjdXPbh8SKTHtsVfVdUn68FbRalQfh2YQ
         Y4Azx7ODO7bHbVk44pwcXa+i+R/4Rl4XxiHNrxUpPBdIQ9v9BXF/IDl7Wc+AllZorMDV
         f1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LAWpY3E6Odlf4ICMNyOR7W/BCVPWauSgjaNbb0CZ754=;
        b=a/OPaaxFBvDnPktIYBujWVHt8dAKASJGe189lF71VuUqaXJny8JM6Kh8HA79G0sdSw
         VmsMRxRzq4PtTT8QyVZH/vyhXzCwVAL4CHGYR9c2rk0vN42PCvtiViBnGzUlACk6mImK
         Sg5Mr0WIlwMg6f33dKmsoO7jW7EXicJFTwWSDuuiLgmtMPUKXKVwBDJTR566uynRpZKI
         CXnjEdSGUxAbUQve6XG+dUnKQvdluwY5kaAntFg28x8xyQZ8Z1hwxTX9FdxF6VRDCeab
         CiWJc2+sCCKyS1V87JGUDkot9D1q5ZAWA9VW1jGTKeP/KREVNJx1kQihlGn4+g7SCy1H
         CCGw==
X-Gm-Message-State: ACrzQf1o8JAeqO1URwDeUQ7tqmGK9WzEBssfXWmStSVv0bbajklz/pbJ
        YgkYzjANsG0p+7OnsWHBLas=
X-Google-Smtp-Source: AMsMyM5aBroRInJXfweYyjIdVdKCfmGI/bcUNBHiVE15B8rCzIH3Lq1fSj2v9UvS/TmL8z29FgMuSA==
X-Received: by 2002:a63:5a46:0:b0:434:e36b:438f with SMTP id k6-20020a635a46000000b00434e36b438fmr9898376pgm.351.1666235757773;
        Wed, 19 Oct 2022 20:15:57 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id on16-20020a17090b1d1000b0020b21019086sm3740594pjb.3.2022.10.19.20.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 20:15:56 -0700 (PDT)
Date:   Wed, 19 Oct 2022 20:15:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] MAINTAINERS: add keyword match on PTP
Message-ID: <Y1C9avfKu3CmmOSL@hoboy.vegasvil.org>
References: <20221020021913.1203867-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020021913.1203867-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 07:19:13PM -0700, Jakub Kicinski wrote:
> Most of PTP drivers live under ethernet and we have to keep
> telling people to CC the PTP maintainers. Let's try a keyword
> match, we can refine as we go if it causes false positives.

This is great, thanks!

Richard
