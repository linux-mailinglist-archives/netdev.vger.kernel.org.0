Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEE26CB4D3
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 05:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjC1D3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 23:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC1D3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 23:29:52 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4A910CF;
        Mon, 27 Mar 2023 20:29:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q102so9608451pjq.3;
        Mon, 27 Mar 2023 20:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679974191; x=1682566191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4oQNXXPHSk+h/Z/8f6Wulz11mYj7JAUcpMZzJ/xe0cY=;
        b=T48wpnhndVIey2DfImqrGAiex+Rn0y7EUFWrh2YEIDsIhVQBgajXAB77Qiy5q4RrHH
         +w82U7uYrW6iWjYepkK7huUkOyyiHHWOqOppzmPSj6BMJB0V5rlq6TdnlJGxIU1p4qJB
         5mG3CDsSaA8Kgaz9FGa/P+Za5BKIms+MN7YCdEDXnKdG73Uh6aOUidi52appcQ/GxPrK
         VuQJA+K5/T+9jsk1XOK3WCfrq96geGEn1i0jOlSDJxP36ubsS1j+6jnz7hJSFlX1E5vg
         WV8X+/jFlnsKwGYcS0AD2wQ7365fT+c51H3TvpW+S+ij37TLVgju5aQucFPkTfD8H+co
         ldJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679974191; x=1682566191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4oQNXXPHSk+h/Z/8f6Wulz11mYj7JAUcpMZzJ/xe0cY=;
        b=cw7IsK23eIGoYcWuqO+EDD0ReWhdvrf9+WA6pnbLsbfhTAhSUE1I1bvvFeseEe6Rc7
         WKreM/EvLO49bA4spHwalmFBGERrJ8wXPmQvLNuxZJZrmR9L4D/c7XG3W42xEUs5AA62
         +ksjS/BdczJc4REdv8agAo2gbNkj/416wDXBdmpDs4bD5DXqO7+mCLKt+v0AmROsQ2OU
         IO3LrONDq7jSkTB9opWKGJex628cV+vh9NDLi6V4LpgOSvykpp6OZNUh9k6H4XuaCEl2
         M8jdYgFtfvOGjHfFxJGvFYJysfEiAxcOXi18UEItU2DSSNuaYqeWYDJc1Mr8xFjXZyDN
         Vk+Q==
X-Gm-Message-State: AO0yUKV83/8rcFGR5mFz6cvvueHsIYLemM9YBASWp0qe8VHbCKcmBwS0
        0NgLta/vYlwwxm7RrCFJ5KSU65f8Dto=
X-Google-Smtp-Source: AK7set8Y4mEq28kbOLKaDDpPt8MiJ220kPDyg7VPyzSFqGtPFp0k/VVt1yfko9G5l4pZ+JLuvRho1w==
X-Received: by 2002:a05:6a20:914b:b0:dc:e387:566b with SMTP id x11-20020a056a20914b00b000dce387566bmr14690515pzc.1.1679974191389;
        Mon, 27 Mar 2023 20:29:51 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w5-20020aa78585000000b005a8dd86018dsm14603552pfn.64.2023.03.27.20.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 20:29:51 -0700 (PDT)
Date:   Mon, 27 Mar 2023 20:29:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shinu Chandran <s4superuser@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: ptp_clock: Fix coding style issues
Message-ID: <ZCJfLIKXyQk5HyZc@hoboy.vegasvil.org>
References: <20230325163135.2431367-1-s4superuser@gmail.com>
 <20230327174746.499fe945@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327174746.499fe945@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 05:47:46PM -0700, Jakub Kicinski wrote:
> On Sat, 25 Mar 2023 22:01:35 +0530 Shinu Chandran wrote:
> > Fixed coding style issues
> 
> If Richard acks we'll take it but as a general rule we try to avoid
> taking pure formatting changes in networking. Too much churn.

Yeah its pointless churn.

NAK on this as the visual impression is not at all improved IMO.

Thanks,
Richard
