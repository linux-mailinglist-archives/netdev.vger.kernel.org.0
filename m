Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396226D54D9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjDCWp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbjDCWpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:45:53 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B59544A7;
        Mon,  3 Apr 2023 15:45:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x3so123278541edb.10;
        Mon, 03 Apr 2023 15:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680561949; x=1683153949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h6RrDwSHkUiqMpG7KHmmT1S8y1MCO0PGFYLZjFaSvc8=;
        b=Pov/C2FNf3GeGCvXxbWtO5LE4WnRCsCk2XfYlc8mm9bLDLqHh/BOXvu2ffyrMrrg4B
         8ysTukjlOlMqNkAE9Zvak33f/11doHKKkyWG6UR2BijRPwQt9nmyW0iVkMKLiMnHQHuN
         8jciXJvsvDpL9I74/L3Ix2QyyJoJNlrf7W6CuJlyVKgsDJT4VaIY5t1eZ9WyVaTmrndA
         3TfGDcZwTQ3lmqRmswNRTuIxeLzN4OAZZtmIEVuUQcBld9oXQTCA809niLypoTaOqlVl
         jDF69DcQjjYQaMVyTB9W6IV/dNJ04etduNoNNjHG2Dgiiy8g0nuDVSHiaj6Sipu6zamY
         6leQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680561949; x=1683153949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6RrDwSHkUiqMpG7KHmmT1S8y1MCO0PGFYLZjFaSvc8=;
        b=pJm0D0E5ADZhUBAWfZ3StdopuqdMwSE0fJ7+uxBzC72io9q5aoVigC6VHZH2gp78c3
         uTlPJhgy+BCcRjaSK8vCTrUmAIyYvKGC7uiarngeDn5r/QmTbbUPjK0utv6YcCiy6gDU
         ETO7KspchtRRQ+nkRg/xwDY2aAObt9HfRh7CKlKlIm71lxpUNLUr9slkXdM/GPuQgZlI
         SezUlMWVGJ9W4PKXI0KdQQj0dykwYHM3j//W0HnyzOJG2szUqQow1OFlVKM6nNYfeYyk
         ij2tHSUQBc1PuCdNGD/nDV9FEVPkK7OtD9j1sBi6ltso/m8sjVYjsP4RnoJ4XcPjPz2f
         yG2A==
X-Gm-Message-State: AAQBX9dr0XODZ/PZIq0hjsAF30cWylJ9LtufDoVZlmMQINwzoJ45p27b
        IuI7Jems6k+FobK3JPsgwtw=
X-Google-Smtp-Source: AKy350YMnOgNOs7DFuWnqJAlUPfOEMenwzvCS0oMoSPtaaRamysxmlb8157KwN+ifsBUfPW/W5ytng==
X-Received: by 2002:a17:906:155:b0:933:fa42:7e36 with SMTP id 21-20020a170906015500b00933fa427e36mr226458ejh.5.1680561949270;
        Mon, 03 Apr 2023 15:45:49 -0700 (PDT)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id hg15-20020a1709072ccf00b00939e76a0cabsm5114169ejc.111.2023.04.03.15.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 15:45:48 -0700 (PDT)
Date:   Tue, 4 Apr 2023 00:45:46 +0200
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2023-03-30
Message-ID: <ZCtXGpqnCUL58Xzu@localhost>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
 <20230331000648.543f2a54@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331000648.543f2a54@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 12:06:48AM -0700, Jakub Kicinski wrote:
> On Thu, 30 Mar 2023 22:56:11 +0200 Johannes Berg wrote:
> >  * hardware timestamping support for some devices/firwmares
> 
> Was Richard CCed on those patches? 
> Would have been good to see his acks there.
> 
> Adding him here in case he wants to take a look 'post factum'.

Timestamping on wifi is something I've spent a fair amount of time
thinking about.  I'll take a look but not this week as I am on
vacation until April 10.

Thanks,
Richard
