Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4450262D92
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 13:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgIILCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 07:02:24 -0400
Received: from smtprelay0003.hostedemail.com ([216.40.44.3]:35116 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729692AbgIILBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 07:01:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 479AC100E7B45;
        Wed,  9 Sep 2020 11:00:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:4225:4321:5007:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21627:30046:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: horn54_50064b2270dc
X-Filterd-Recvd-Size: 1987
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Wed,  9 Sep 2020 11:00:17 +0000 (UTC)
Message-ID: <e2dfa0e0c279cd39a0b7ab725a634831e1f188cc.camel@perches.com>
Subject: Re: [PATCH][next] mt7601u: Use fallthrough pseudo-keyword
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 09 Sep 2020 04:00:16 -0700
In-Reply-To: <20200901173603.GA2701@embeddedor>
References: <20200901173603.GA2701@embeddedor>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-09-01 at 12:36 -0500, Gustavo A. R. Silva wrote:
> Replace the existing /* fall through */ comments and its variants with
> the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> fall-through markings when it is the case.
[]
> diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
[]
> @@ -196,7 +196,7 @@ static void mt7601u_complete_rx(struct urb *urb)
>  	default:
>  		dev_err_ratelimited(dev->dev, "rx urb failed: %d\n",
>  				    urb->status);
> -		/* fall through */
> +		fallthrough;
		
		fallthrough to break is odd.
		break would probably be better.

>  	case 0:
>  		break;
>  	}
> @@ -241,7 +241,7 @@ static void mt7601u_complete_tx(struct urb *urb)
>  	default:
>  		dev_err_ratelimited(dev->dev, "tx urb failed: %d\n",
>  				    urb->status);
> -		/* fall through */
> +		fallthrough;

here too...

>  	case 0:
>  		break;
>  	}
> 

