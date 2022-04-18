Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AE5504BBB
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 06:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbiDREmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 00:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbiDREmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 00:42:11 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCC317A92
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 21:39:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ll10so12071625pjb.5
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 21:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7SSnpAzVTF5J7ZCSttOckU3A0ZgrigpMpTDYMsnhtCs=;
        b=boocnxldWlzkxntYmwyjMkWaXHezeo//bR/B8AlUFD9kXem6/TauspAdanRMrsCCFZ
         7IbwaEtyJ2JWGdWKwk0hfhyXQALG8ngy0vQy1kNMpVBHo2kx3PBGAeBKFU/ihoQgjCZb
         B2mLDKNi+ZuuPldT/HEZQ5qiCYofpXqoO0LyFlWuv+6Wy0Qe8sooSGLsp3S0GUfFdf7H
         iK+6aV+nN+VZtROyukqZ3sr0zjkwEs1HWkDoji7W+tf3hGnykHHggKTPTA5rN1EDJLRI
         kX1UCTBpbHAv0nQdCuT8bnuvmP14yp7Nrzug7elwYJTNgU0Rfb7P0O6bdOLLB3OAW9sY
         p1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7SSnpAzVTF5J7ZCSttOckU3A0ZgrigpMpTDYMsnhtCs=;
        b=c5s8YsOgq+Ot+F6O1EIfyT75m4lV6aO2QSChHdeLXcXDLkY+kBzSv9T4AC1RJ7ZJFE
         bSKzAx8w69+PB6D+B3Xr2VRq+5FqQmgHlgvN2tinTgehn49f/1/c5ixo30+tx2RfuH7H
         laSSqbZEWK8EYecjVm1CXVaZieJWK+d9HrsTaqC/YjmMn1z8UVCPPOSxm2eksriRtwPt
         KmgKU8P0CDvIq/x1uMEIUF5QZa+Wlynv7/27/c+ZdZYV3WKIhPz/TObyjd/KoIPRsl93
         XERytzx+xqpgwaFY2Ic7TUM3WpEqr/cyDEW0OYYYFlDplqZUNa3tAE/4KXVK3lDo+VQY
         gJ4g==
X-Gm-Message-State: AOAM533uuT6Qc0ivcw0ggkzKVJ1fZBCYvi7ezM7rZrmOT1eSlRYSypRf
        bfGKOgTWgWQMRIEbC3s7wKP57HDREzo=
X-Google-Smtp-Source: ABdhPJw2igkfhJvoUL+ZvwYw0jvXfAAxxEK9tRN72kzWttj5iAAdgHtAcr/oaNjYffpFNTxrqLRDFA==
X-Received: by 2002:a17:903:2441:b0:159:208:755c with SMTP id l1-20020a170903244100b001590208755cmr2643111pls.160.1650256773477;
        Sun, 17 Apr 2022 21:39:33 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id e15-20020a63ae4f000000b003995a4ce0aasm11300755pgp.22.2022.04.17.21.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 21:39:32 -0700 (PDT)
Date:   Mon, 18 Apr 2022 13:39:28 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Baligh Gasmi <gasmibal@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH] ip/iplink_virt_wifi: add support for virt_wifi
Message-ID: <YlzrgBRC62Dv1RrO@d3>
References: <20220417225318.18765-1-gasmibal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220417225318.18765-1-gasmibal@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-18 00:53 +0200, Baligh Gasmi wrote:
> Add support for creating virt_wifi devices type.
> 
> Syntax:
> $ ip link add link eth0 name wlan0 type virt_wifi
> 
> Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
> ---
>  ip/Makefile           |  2 +-
>  ip/iplink_virt_wifi.c | 24 ++++++++++++++++++++++++

I think man/man8/ip-link.8.in should also be updated.
