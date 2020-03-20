Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DF318CC1C
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgCTLDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:03:33 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:39339 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgCTLDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:03:33 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 96A8022F2D;
        Fri, 20 Mar 2020 12:03:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1584702209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gUkotz8OFFBMd9PmlQFXSI+efiAIa/TYqSLX2WL8g28=;
        b=A3Gz3E5G1Gem0xRzkSd0oeQk+cgMuLYcVtYDXHrlGssh5Q5Hs/Nm7cG3jf4WjYMzk8eR8M
        1VMA6tmMfaeR+B11jg/Lgk6lj5QoUMoTlyg373DjtD63bJopsfBY9F6cClgZ24FIcHYWWP
        IAULBD/aLkz15S1EhwkBHlAEF0wQD3I=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Mar 2020 12:03:28 +0100
From:   Michael Walle <michael@walle.cc>
To:     David Miller <davem@davemloft.net>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        robh+dt@kernel.org, leoyang.li@nxp.com, shawnguo@kernel.org
Subject: Re: [PATCH 1/2] net: dsa: felix: allow the device to be disabled
In-Reply-To: <20200314.205335.907987569817755804.davem@davemloft.net>
References: <20200312164320.22349-1-michael@walle.cc>
 <20200314.205335.907987569817755804.davem@davemloft.net>
Message-ID: <516fced37ce8b390e89eb0557b0b7362@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 96A8022F2D
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_TWELVE(0.00)[13];
         NEURAL_HAM(-0.00)[-0.632];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[lists.infradead.org,vger.kernel.org,gmail.com,lunn.ch,nxp.com,kernel.org];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Hi Shawnguo,

Am 2020-03-15 04:53, schrieb David Miller:
> This series depends upon some devicetree tree changes, so why don't you
> submit these changes there and add my:
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
> Thank you.

Patch 2/2 is already in linux-next, picked by Shawnguo. Who will
pick 1/2? I guess it doesn't matter through which tree it will go.

-michael
