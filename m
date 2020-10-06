Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC77F284D65
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgJFONl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFONl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:13:41 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE56C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 07:13:40 -0700 (PDT)
Received: from localhost.localdomain (p200300e9d72c3c4353f06c511a49ff67.dip0.t-ipconnect.de [IPv6:2003:e9:d72c:3c43:53f0:6c51:1a49:ff67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C1285C3D16;
        Tue,  6 Oct 2020 16:13:37 +0200 (CEST)
Subject: Re: [PATCH v5 25/52] docs: net: ieee802154.rst: fix C expressions
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexander Aring <alex.aring@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1601992016.git.mchehab+huawei@kernel.org>
 <6ba1d137516e4a144a4fd398934d62b94d31446d.1601992016.git.mchehab+huawei@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <ec4c5132-8b45-d2e7-b414-003000def8f8@datenfreihafen.org>
Date:   Tue, 6 Oct 2020 16:13:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <6ba1d137516e4a144a4fd398934d62b94d31446d.1601992016.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06.10.20 16:03, Mauro Carvalho Chehab wrote:
> There are some warnings produced with Sphinx 3.x:
> 
> 	Documentation/networking/ieee802154.rst:29: WARNING: Error in declarator or parameters
> 	Invalid C declaration: Expecting "(" in parameters. [error at 7]
> 	  int sd = socket(PF_IEEE802154, SOCK_DGRAM, 0);
> 	  -------^
> 	Documentation/networking/ieee802154.rst:134: WARNING: Invalid C declaration: Expected end of definition. [error at 81]
> 	  void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi):
> 	  ---------------------------------------------------------------------------------^
> 	Documentation/networking/ieee802154.rst:139: WARNING: Invalid C declaration: Expected end of definition. [error at 95]
> 	  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb, bool ifs_handling):
> 	  -----------------------------------------------------------------------------------------------^
> 	Documentation/networking/ieee802154.rst:158: WARNING: Invalid C declaration: Expected end of definition. [error at 35]
> 	  int start(struct ieee802154_hw *hw):
> 	  -----------------------------------^
> 	Documentation/networking/ieee802154.rst:162: WARNING: Invalid C declaration: Expected end of definition. [error at 35]
> 	  void stop(struct ieee802154_hw *hw):
> 	  -----------------------------------^
> 	Documentation/networking/ieee802154.rst:166: WARNING: Invalid C declaration: Expected end of definition. [error at 61]
> 	  int xmit_async(struct ieee802154_hw *hw, struct sk_buff *skb):
> 	  -------------------------------------------------------------^
> 	Documentation/networking/ieee802154.rst:171: WARNING: Invalid C declaration: Expected end of definition. [error at 43]
> 	  int ed(struct ieee802154_hw *hw, u8 *level):
> 	  -------------------------------------------^
> 	Documentation/networking/ieee802154.rst:176: WARNING: Invalid C declaration: Expected end of definition. [error at 62]
> 	  int set_channel(struct ieee802154_hw *hw, u8 page, u8 channel):
> 	  --------------------------------------------------------------^
> 
> Caused by some bad c:function: prototypes. Fix them.
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>   Documentation/networking/ieee802154.rst | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/networking/ieee802154.rst b/Documentation/networking/ieee802154.rst
> index 6f4bf8447a21..f27856d77c8b 100644
> --- a/Documentation/networking/ieee802154.rst
> +++ b/Documentation/networking/ieee802154.rst
> @@ -26,7 +26,9 @@ The stack is composed of three main parts:
>   Socket API
>   ==========
>   
> -.. c:function:: int sd = socket(PF_IEEE802154, SOCK_DGRAM, 0);
> +::
> +
> +    int sd = socket(PF_IEEE802154, SOCK_DGRAM, 0);
>   
>   The address family, socket addresses etc. are defined in the
>   include/net/af_ieee802154.h header or in the special header
> @@ -131,12 +133,12 @@ Register PHY in the system.
>   
>   Freeing registered PHY.
>   
> -.. c:function:: void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi):
> +.. c:function:: void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi)
>   
>   Telling 802.15.4 module there is a new received frame in the skb with
>   the RF Link Quality Indicator (LQI) from the hardware device.
>   
> -.. c:function:: void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb, bool ifs_handling):
> +.. c:function:: void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb, bool ifs_handling)
>   
>   Telling 802.15.4 module the frame in the skb is or going to be
>   transmitted through the hardware device
> @@ -155,25 +157,25 @@ operations structure at least::
>           ...
>      };
>   
> -.. c:function:: int start(struct ieee802154_hw *hw):
> +.. c:function:: int start(struct ieee802154_hw *hw)
>   
>   Handler that 802.15.4 module calls for the hardware device initialization.
>   
> -.. c:function:: void stop(struct ieee802154_hw *hw):
> +.. c:function:: void stop(struct ieee802154_hw *hw)
>   
>   Handler that 802.15.4 module calls for the hardware device cleanup.
>   
> -.. c:function:: int xmit_async(struct ieee802154_hw *hw, struct sk_buff *skb):
> +.. c:function:: int xmit_async(struct ieee802154_hw *hw, struct sk_buff *skb)
>   
>   Handler that 802.15.4 module calls for each frame in the skb going to be
>   transmitted through the hardware device.
>   
> -.. c:function:: int ed(struct ieee802154_hw *hw, u8 *level):
> +.. c:function:: int ed(struct ieee802154_hw *hw, u8 *level)
>   
>   Handler that 802.15.4 module calls for Energy Detection from the hardware
>   device.
>   
> -.. c:function:: int set_channel(struct ieee802154_hw *hw, u8 page, u8 channel):
> +.. c:function:: int set_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
>   
>   Set radio for listening on specific channel of the hardware device.
>   
> 
