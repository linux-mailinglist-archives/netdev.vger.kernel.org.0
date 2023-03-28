Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C81F6CB4D5
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 05:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjC1Da4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 23:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC1Daz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 23:30:55 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B27F132;
        Mon, 27 Mar 2023 20:30:54 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id ix20so10406238plb.3;
        Mon, 27 Mar 2023 20:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679974253; x=1682566253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hK28NLLSw48qd1BofUmIYRdm9R5LsiZdbV674M7YtaA=;
        b=LrxqMbaL6SgCu29Fqk7L5MaV8L4xcOPoMUUT1nVzp+Bwds7eJNwP8foAAqiqrtBKYq
         uVuNaZO8eYmxFQ5X3kiGXRo49QfZwKQPXRtXyi5BWxYGJGwRaDdvqofMOWC9iuZ83FSn
         ym2XT2Mwfibh1ZbArdlYXb4yumFj0rrR8dNbkzLjbrCjcZejJl72TX+AEF1zBAOiQp7z
         embSKN+s0rm6PfRVP+Nw/eDLudqq8mJH+ninl955mqPBuRMW/ByEP2XqXsLnIx0JzmZu
         tpzNxxRmpoD4IrymhJi0lEp1r590gOKsJqSFU2jDzJQH9MH7KBO7KXOUcm6Xtgs91In5
         k4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679974253; x=1682566253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hK28NLLSw48qd1BofUmIYRdm9R5LsiZdbV674M7YtaA=;
        b=ZRi7f15tDGwK+7n04CfzGGkqVlzYQW+vaTINcch4d8dvQjl9YUS6JXvnO2i4GYmznk
         ira2CcrrwhRDzLtUhCR6epQgYs4vDTjJu+dEZNx4MYB36hdAZMxkCUbvhp9J1BqdoIw4
         n+scHWex5aoyVo6eMF7FR2HCWEdNWcfMjDwk8xXfLjgiCKBecLYdqcDQnKGxsbJp1MYv
         Dg8+Eg2k6Bbc1ezw6iZu0yD6mKdAH+OWJ+sh4xZDH0EgzZFP+L/xtXgux6GpDLhWrLz5
         7J7DFGnVFiNmrWdieSAoiumQTlSqmhThePW1WKxy9NV0/kUahW/XLFEzRGifngl6mDPF
         qXuA==
X-Gm-Message-State: AO0yUKWEjSK2Lh3Ai3gxlC2jAPFPqn6RsldCsoJz6r/aySYxv+Kh4At8
        6wd4+EcKDUrvB8M5mIjEKRo=
X-Google-Smtp-Source: AK7set/VGDcfRlPfKwkYw/OG0hy0LFR10Qxmjs2CoJ7tgKocB18K9Ji5+1yvROALF/bpRZW90C9HvQ==
X-Received: by 2002:a05:6a20:8e08:b0:cd:2c0a:6ec0 with SMTP id y8-20020a056a208e0800b000cd2c0a6ec0mr20539331pzj.3.1679974253603;
        Mon, 27 Mar 2023 20:30:53 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x8-20020aa79188000000b0062622ae3648sm19635258pfa.78.2023.03.27.20.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 20:30:53 -0700 (PDT)
Date:   Mon, 27 Mar 2023 20:30:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shinu Chandran <shinucha@cisco.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: ptp_clock: Fix coding style issues in ptp_clock
Message-ID: <ZCJfa5pVanIrGnmv@hoboy.vegasvil.org>
References: <20230325164232.2434190-1-shinucha@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325164232.2434190-1-shinucha@cisco.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 10:12:32PM +0530, Shinu Chandran wrote:
> Fixed coding style issues in ptp_clock.c
> 
> Signed-off-by: Shinu Chandran <shinucha@cisco.com>

NAK.

(No) Thanks,
Richard
