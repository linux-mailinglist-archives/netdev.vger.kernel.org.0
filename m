Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12E16BCD80
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCPLFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjCPLFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:05:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1C76C884;
        Thu, 16 Mar 2023 04:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A11A61FDB;
        Thu, 16 Mar 2023 11:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8E6C433A0;
        Thu, 16 Mar 2023 11:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678964733;
        bh=jwdsqFj42Pawn1NF91CaXMc12zQ2/CQZq6KOHz+TFDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AOvS2dgIC9QgqUFLjiIKRrVFOe987AJjXYAqBEzcaczX3b9qM1h505TNB8EK3PpEZ
         aHI49DbigXKkh+7n+9NBHP4PffBoOZvLHKe6r994l6kwB5gASJpP/K4L6mn1zf8QAo
         SFl+jX3sqpHD3IMOFrRSbFyTA2xuOsvhosCQ+udQwC1YwEh1815+j0pcEMuEjPhcen
         th63Onh11g+ZA6l8b2cGUviZgUxJgSi9tapL7TXBRRS5CL0yIcGK9oCZ+bt2EgncEf
         fO1EnwZgLYy0YQLFzmoriiW0KlGZxVudHk2wui9bf47bIPTE7b0nD2NLZa7Z1yiHxY
         +hnKqaTAmNmRg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pclRS-0004wx-Gp; Thu, 16 Mar 2023 12:06:42 +0100
Date:   Thu, 16 Mar 2023 12:06:42 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
Subject: Re: [PATCH v6 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Message-ID: <ZBL4Qrp9Lr+aOyXr@hovoldconsulting.com>
References: <20230316034759.73489-1-steev@kali.org>
 <20230316034759.73489-5-steev@kali.org>
 <ZBLuxFxFvCY+0XHG@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBLuxFxFvCY+0XHG@hovoldconsulting.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 11:26:12AM +0100, Johan Hovold wrote:
> On Wed, Mar 15, 2023 at 10:47:58PM -0500, Steev Klimaszewski wrote:
> > The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
> > add this.
> > 
> > Signed-off-by: Steev Klimaszewski <steev@kali.org>
> > ---
 
> > +		vreg_s1c: smps1 {
> > +			regulator-name = "vreg_s1c";
> > +			regulator-min-microvolt = <1880000>;
> > +			regulator-max-microvolt = <1900000>;
> > +			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
> > +			regulator-allowed-modes = <RPMH_REGULATOR_MODE_AUTO>,
> > +						  <RPMH_REGULATOR_MODE_RET>;
> > +			regulator-allow-set-load;
> 
> So this does not look quite right still as you're specifying an initial
> mode which is not listed as allowed.
> 
> Also there are no other in-tree users of RPMH_REGULATOR_MODE_RET and
> AUTO is used to switch mode automatically which seems odd to use with
> allow-set-load.
> 
> This regulator is in fact also used by the wifi part of the chip and as
> that driver does not set any loads so we may end up with a regulator in
> retention mode while wifi is in use.
> 
> Perhaps Bjorn can enlighten us, but my guess is that this should just be
> "intial-mode = AUTO" (or even HPM, but I have no idea where this came
> from originally).

This one probably also needs to be marked as always-on as we don't
currently describe the fact that the wifi part also uses s1c.

Johan
