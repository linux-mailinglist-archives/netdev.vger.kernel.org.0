Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C806C4FE1
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjCVQBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjCVQBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:01:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEBC65C5A;
        Wed, 22 Mar 2023 09:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEBC2B81D43;
        Wed, 22 Mar 2023 16:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D1EC4339B;
        Wed, 22 Mar 2023 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679500902;
        bh=K3bCYBTQOn4c0hzSgPQwLYUkrJbrk5PNnqW5DdmlM+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DJLiyvN9dxs4Y03eDaOYkXHdoCshS9bKS4kXrhlIFgHn0lOsuHs3JOMAXEndJ8vms
         JyqJ/rqsVm/7Yq/4bUYC+Wpysn7+9i1aUCoybxa/4m3hVLtE6UI2N58vfT1YL7Dhhp
         5IrBQb7JURYwt1dS8EE6U3eEG5g4QY8yWg4VZY75vL0DUKrAVoe0E18kCVugfpdTCN
         nEgvn25PmJ7/zmXmTJ0TYTqrE9CSWfjkRULcaL4Qttd+g9+qk3fxJgP7c480u4xqGS
         bCQjFChhTk+4tb1hAujPOov9P883sI8SsIE1H6tRuUKIMYPkwf/NsT/qTy0P9cW2jJ
         tda1usOk15KoQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pf0vc-000687-Re; Wed, 22 Mar 2023 17:03:08 +0100
Date:   Wed, 22 Mar 2023 17:03:08 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
Subject: Re: [PATCH v7 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Message-ID: <ZBsmvGylo+yghiFG@hovoldconsulting.com>
References: <20230322011442.34475-1-steev@kali.org>
 <20230322011442.34475-5-steev@kali.org>
 <ZBrpyXrkHDTQ6Z+l@hovoldconsulting.com>
 <CAKXuJqiirOEuvhHUtqeGvFjxkTR21SxKXe8Hysayx5UXFpukUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKXuJqiirOEuvhHUtqeGvFjxkTR21SxKXe8Hysayx5UXFpukUQ@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 10:35:03AM -0500, Steev Klimaszewski wrote:
> On Wed, Mar 22, 2023 at 6:41 AM Johan Hovold <johan@kernel.org> wrote:

> > I went through the schematics to check for further problems with
> > consumers that are not yet described and found a few more bugs:
> >
> >         https://lore.kernel.org/lkml/20230322113318.17908-1-johan+linaro@kernel.org
> >
> > Note that that series is now adding the s1c supply as it also used by
> > some of the pmics.
> >
> > I'm assuming those fixes may get merged before this patch is, in which
> > case the above hunk should be dropped.
> >
> 
> I can spin up v8 dropping this hunk and mention the dependency on that
> series.

Sounds good. Bjorn has even merged the above series now.

Johan
