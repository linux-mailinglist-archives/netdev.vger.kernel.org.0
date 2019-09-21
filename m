Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD2EB9BDA
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 03:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbfIUBc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 21:32:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42145 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730577AbfIUBc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 21:32:26 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so5702958pff.9
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 18:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JHo9M9g3ayOFP0H8C0h/frjLeyoKyqg1lMQyo2UJSPQ=;
        b=GM2v0nDPn116/2keY8CPd1k+K71qZvyOc13QWRJt0wXlP1GriD5C1pnZ58sMCVhKk+
         OO+v9sdsPsFD4299pX+XCFKADAtXw5NGbxme2AcdOKZaAXjh5Kmdrbm3pg+dbYC8InPb
         04y6ldQhblYP/r4rBf28TtxpVOFqGo3cZiMhvKXzEWRMXtl6UB9IqaukIABruq5k9piJ
         z0R9NNqEgT8ZwSD2CuavUebjB/KywXy8xuhagddl5im1aHdv0syz2PvwT/tBDsbyf4y9
         J/G8KtN62PzMe/zDkzFE1g58cB5vKt11TXc9SI41MtGKcro+FAnuTMqP8nvkjZ6Av2Eo
         7dhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JHo9M9g3ayOFP0H8C0h/frjLeyoKyqg1lMQyo2UJSPQ=;
        b=YP3PdALeH+KmA2drkboGn+E5S52nsmuX4XasN1mfViYoj/EUtr+zxFPBpmItg5VvQh
         sqPFrbYsplHt7d8Zmow8ki0caLyy510U0nDakkp9+X2TOXKAYMmqdRl/WYdwvskN4wzW
         S6qcqCHCP0myv8QvA+VEc7CjLP6S0lezy5EqqMWRe2xxtmkusQETJeciIgq/7y3rECRZ
         vXBIgI9SlwhVfS+WChx+FJmIn/rPu1p+SO4r56nK1h2rh9YY8TtVAVW1qIiFf6a7c17a
         eC6V+e2P+Qux+xUG74TO9JAxU8L6xwqAzhANP67N6RCUuN6Ez6Frl8+f+lVHRVL3S8Uh
         09Wg==
X-Gm-Message-State: APjAAAWNoRZxA9gZigMOxmO59+UdnHp6UU1/VhKGGplTyFN9TO910MIC
        ENdHULy1CUGauBWDQWCfbp8=
X-Google-Smtp-Source: APXvYqzFd8b5y19YNQOtynhlRO5YG9v2SOzjWuAtydNOD5FIKmOMYf4hjks+U531tNuqTvGOv7UMHQ==
X-Received: by 2002:a17:90a:e56:: with SMTP id p22mr7913125pja.133.1569029545271;
        Fri, 20 Sep 2019 18:32:25 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:bd3e:db6:d703:4870])
        by smtp.googlemail.com with ESMTPSA id r28sm5480640pfg.62.2019.09.20.18.32.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 18:32:24 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: Revert removal of rt_uses_gateway
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ja@ssi.bg
References: <20190917173949.19982-1-dsahern@kernel.org>
 <20190920183041.7c57b973@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b09ff179-297b-19ce-f467-99b8315ee2d6@gmail.com>
Date:   Fri, 20 Sep 2019 19:32:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190920183041.7c57b973@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/19 7:30 PM, Jakub Kicinski wrote:
> I'm assuming the mix of u8 and __u8 is intentional, since this is a partial revert :)

original patch for rt_uses_gateway used __u8 so yes put that back.

not sure why I used u8 for the new field, but left it on the move.
