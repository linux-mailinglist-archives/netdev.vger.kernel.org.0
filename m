Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB9C1758FC
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 12:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgCBLCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 06:02:05 -0500
Received: from mout.gmx.net ([212.227.17.21]:58637 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgCBLCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 06:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1583146911;
        bh=n00UB7z2/BFRhPrdZi/F5/kFy7qQNu6rbL7LhtCVI5I=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=WR6dw9a9XYfSu3hRNgP5iNhOOsOeQCtgO0biiMVA59oRj5t+rHQjlyefPuN06W5xS
         viy1enOjYxZ8+IBNSThF+4xI9yRS9TyyxR0L7YOgdNBMKm27XV9MtLeKHwAGIKRUQl
         kCBOBG1oLZOKNrhnljsGOU0980IhAJVZdj143IC8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.2.2.136] ([85.220.165.66]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MF3DM-1jAugw3o6K-00FX2I; Mon, 02
 Mar 2020 12:01:50 +0100
Subject: Re: [PATCH 1/2] ag71xx: Add support for RMII, RGMII and SGMII
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com, jcliburn@gmail.com
References: <20200302001830.14278-1-hauke@hauke-m.de>
From:   Oleksij Rempel <linux@rempel-privat.de>
Autocrypt: addr=linux@rempel-privat.de; prefer-encrypt=mutual; keydata=
 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
 Rmpernzn0GXR0xYSTiUvuvpLsoo=
Message-ID: <aa21c71b-131e-568b-9e18-b74dd9af1b8f@rempel-privat.de>
Date:   Mon, 2 Mar 2020 12:01:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302001830.14278-1-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MELIB+vSvTcNOcmiSiLbTw0vxyfudrsuQH4ZVSk8zZBEtlLB29U
 AJUKvo7SjsO1u5fNNJ2itNWEBjVm7xyyrkzEZaHdGJ5lJIUcdje0b3bkFGXbvEU7pP1b75D
 6EwJCUzNLufT5xFVcRdfHC0A5mAhrRPRiIDX56A9vENUSaFiOjxR0Bha6Qj9i13qGbhVpEn
 vW3QEM6IaBtXSw1gT5svg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tY3Sz5gkZD4=:tFCOfu4PbogBESU7e1kXl3
 ZhUQOjxrefKkNDu3xFxHuKMQPzSSBtCpp4QdBeU2AZIz7ubZlf1QzD4pLZtjjrBlAOlrFSrJ3
 ikYuw76NAfemnRW7bdElEumA+XzGMSY3KLY9/5v3MXcdLk1LvhD1Vc9l13SFcsD5erHzYO/IS
 sa5nj7UiPhbzrG6Z4Fga44RcmL+JQnnfffQzfPmOVwsAgSkAGHlfnIjtBsdG6JsNehzp3I1CQ
 3peulV8688R+3Z7Ox+7eQGKzhp3Y2PdwwyUo7kpaD7VPo0I4rqBFTGmjukfv0TsQ+Cs+oDI5K
 tDRRTzuzND+CfqvNT4DPqdl+3yYOtPO2JGkzp9U2n6SMzt9p37pn3BQD4C8LEbg+KosXIuL3t
 8N0ik9aCNUPFO2Lxt13C8cwEnEE6JGfF+71NUjwlK2La4Gw2C4erlTXG2GslXbNbaeGS37w4e
 eMBPjRk3SzMEE8ogfUX851uItqR0nBzQgPaMhTK0+WVwjBSy2MqzQOvuvt8CHFiizcZ7HbZM+
 8Y27mT9IRIwm4GJysvkaWUhFv3808YoUZ/8BiDTdj3BSpcRjoOddu/vtEeq3M5s/0pg4Ud0LH
 ki1snNjVVIOowzNyWXoNPC8gVPkS0pEw2eYnSyu5bXLOL3FPlueyLKS1QmTYrRBAlF+kdv9XH
 ojr6inm2VZVX3pELydULqucjvqOF+dHzA612KgWA7YRq/Jkr9/+CNI2ouFkgETaiA3ppZFlhf
 zoxruWqnpjBTtF0RhalRzB5i3VBm5n2A7OIEJdd8d5uZBpD32wK9FbIohI7qfiQywUTv+PbAl
 XYM50tEd7/Ilc/yaWAKMBMXt9aBZqAHJmfosY/dzsMNI+B4HEhiixPHzJ2rEkcJvEDtpe+dsv
 7r8xfWa9hJSaE5z76NlFGgUVcfepDjK6CB0YTqbPKJXErumXQh5oXbuuf9scyvPacbY4qVCv0
 +7LRGBqIs5hcwDkqW6p/42HCdLfabjpv0DV3wK6S7NwcuVedd3TeQKngq44tWkO4tdeIMsQV2
 rMASO9dEf4/HOWvX20A9T9tJ3zvQ0GA8ESo9ZVmRzG7iVC37ctiRT0Q7rnIjHQt9UcDBXMBjq
 78ctWEBVrRKeuvOnAXECNCpJlpZYr7WV92DT+Nw7zsOXMY8y0O+q+99EYPnSFjc1REGU595UN
 RvpknAwtMut6ki3HxXqUtYuLsKk3r68w9oNSomXUjDCSeBmLMM+Zpf01Vh1IwENnPG9NJK7K5
 d175RR3sqtf/AH5EF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 02.03.20 um 01:18 schrieb Hauke Mehrtens:
> The GMAC0 on the AR9344 also supports RMII and RGMII. This is an
> external interface which gets connected to an external PHY or an
> external switch. Without this patch the driver does not load on PHYs
> configured to RMII or RGMII.
>
> The QCA9563 often uses SGMII to connect to external switches.
>
> This still misses the external interface configuration, but that was
> also not done before the switch to phylink.
>
> Fixes: 892e09153fa3 ("net: ag71xx: port to phylink")
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/ethernet/atheros/ag71xx.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/etherne=
t/atheros/ag71xx.c
> index 02b7705393ca..69125f870363 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -874,8 +874,11 @@ static void ag71xx_mac_validate(struct phylink_conf=
ig *config,
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
>
>  	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
> +	    state->interface !=3D PHY_INTERFACE_MODE_MII &&
> +	    state->interface !=3D PHY_INTERFACE_MODE_RMII &&
>  	    state->interface !=3D PHY_INTERFACE_MODE_GMII &&
> -	    state->interface !=3D PHY_INTERFACE_MODE_MII) {
> +	    state->interface !=3D PHY_INTERFACE_MODE_SGMII &&
> +	    phy_interface_mode_is_rgmii(state->interface)) {
>  		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>  		return;
>  	}

Starting from now we need to do validation based on port and SoC. Not all =
mode are valid for all SoC
and ports. See ar9331_sw_phylink_validate as example.

> @@ -889,7 +892,9 @@ static void ag71xx_mac_validate(struct phylink_confi=
g *config,
>  	phylink_set(mask, 100baseT_Full);
>
>  	if (state->interface =3D=3D PHY_INTERFACE_MODE_NA ||
> -	    state->interface =3D=3D PHY_INTERFACE_MODE_GMII) {
> +	    state->interface =3D=3D PHY_INTERFACE_MODE_GMII ||
> +	    state->interface =3D=3D PHY_INTERFACE_MODE_SGMII ||
> +	    phy_interface_mode_is_rgmii(state->interface)) {
>  		phylink_set(mask, 1000baseT_Full);
>  		phylink_set(mask, 1000baseX_Full);
>  	}
>


=2D-
Regards,
Oleksij
