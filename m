Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A38755ED9E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbiF1TJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbiF1TJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:09:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5AD11475;
        Tue, 28 Jun 2022 12:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C089CB81F65;
        Tue, 28 Jun 2022 19:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E57C341C6;
        Tue, 28 Jun 2022 19:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656443342;
        bh=vyOSRFaeOHg/nlsNMOcqGK6kvTCU3fo60wFj/4X1Q9s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pVAfkfEeuF5/S6JxTRpRbMjqjB1mzr9IML9oX7D8h4c1egD7DPSqsw7LEzC6AFRMZ
         AZF0Rvt9w/2UTEEx2G5LGgErQzTmXB8rOCE8MJZGq251Fj6dj4wO8/LXnYcuU3k5Fg
         7WKjhjcFfwje1aTfVeIXXaCre8R+lxKZgpmDvUtnAAvwTUtO4RXtAsGZKI61/6ZG84
         pAIkH6/u2EYsz0HiRCdF7Ej3RP8VTvxdRyuAnRi1Y4QqYX6+KwPg7IBhVzMseiKWOz
         GttMSOZiQIjxaBMGC/S1nXDLsDEYBao5ZnQfrmQgZosY5Ghkj4UnJFdASaHiJHUaOM
         0vyBTi/brLYSg==
Date:   Tue, 28 Jun 2022 12:09:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH] dt-bindings: nfc: nxp,nci: drop Charles Gorand's mail
Message-ID: <20220628120901.693b1470@kernel.org>
In-Reply-To: <20220628182635.GA748152-robh@kernel.org>
References: <20220628070959.187734-1-michael@walle.cc>
        <20220628182635.GA748152-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 12:26:35 -0600 Rob Herring wrote:
> On Tue, 28 Jun 2022 09:09:59 +0200, Michael Walle wrote:
> > Mails to Charles get an auto reply, that he is no longer working at
> > Eff'Innov technologies. Remove the entry.
> > 
> > Signed-off-by: Michael Walle <michael@walle.cc>
> > ---
> >  Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml | 1 -
> >  1 file changed, 1 deletion(-)
> >   
> 
> Applied, thanks!

I thought you said you prefer binding changes to go thru relevant
trees. Not that I care which way the default is but let's stick 
to one.
