Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8424B5624E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 08:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfFZG0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 02:26:21 -0400
Received: from first.geanix.com ([116.203.34.67]:59366 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbfFZG0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 02:26:20 -0400
Received: from [192.168.100.94] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 1FEB8A8C;
        Wed, 26 Jun 2019 06:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1561530346; bh=NDzWY1mn8lR9WsNTeOSRA7DhTJGZznkTv0X6E2FIZ0k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=UBaIRenG4Cel4QngwSQ1B2hHFpou0eDA/c+J/ub1C3MTrt/jHs2A4lrSvuLxqhL0x
         2AyWZxz0UBtrh+aqOSqIrin9+IQgBbjf8eZaIWe6WYmg/30Kcu5vexu6gDtM30iGMS
         /ds5jksQ2rY2PDsDsOjT1aiXltgUkS45rKrHNYHNYBseg7Jo7ADD8GuMdztswItfvL
         jtUQXFUq3MEPnZNgWNqJ6Tbk2/k7C8sY4rH1IjROks7Y54ZMsOgLxHdPi6baVHBaD7
         mf4lS7wo/IRFKl+xoDgS77gbarFvId89gC9EisZvaYGvelNFQnzyc4h/HopvsXxWiu
         Qrx41MMrxhEjQ==
Subject: Re: [PATCH] can: mcp251x: add error check when wq alloc failed
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Weitao Hou <houweitaoo@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        allison@lohutok.net, tglx@linutronix.de, linux-can@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20190625125048.28849-1-houweitaoo@gmail.com>
 <CA+FuTSegsUvPSWX+CZuafSD32Sx+xJmYPiQ92geDNqAe8_JGrQ@mail.gmail.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <6a678bc9-648e-e566-9781-2b42a678ed86@geanix.com>
Date:   Wed, 26 Jun 2019 08:26:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CA+FuTSegsUvPSWX+CZuafSD32Sx+xJmYPiQ92geDNqAe8_JGrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 884f5ce5917a
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/06/2019 16.03, Willem de Bruijn wrote:
> On Tue, Jun 25, 2019 at 8:51 AM Weitao Hou <houweitaoo@gmail.com> wrote:
>>
>> add error check when workqueue alloc failed, and remove
>> redundant code to make it clear
>>
>> Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> 
Tested-by: Sean Nyekjaer <sean@geanix.com>
