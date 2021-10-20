Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF52435530
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 23:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhJTVTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 17:19:04 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:44614 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJTVTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 17:19:03 -0400
Received: from [IPv6:2003:e9:d74b:bb37:2d11:3826:d66f:93f7] (p200300e9d74bbb372d113826d66f93f7.dip0.t-ipconnect.de [IPv6:2003:e9:d74b:bb37:2d11:3826:d66f:93f7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 6AF53C0876;
        Wed, 20 Oct 2021 23:16:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1634764607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HRKKgMcsIJStdVH35Z1WYKPkQvB/n1SCcEn2UNHPJVA=;
        b=cBcl6tsoJVuh6+6jYRUlDtvPkQYKS0HT5WzrUpnl3OjLrYpsJHdj+27cgZ0AynaTiOSYx4
        F6UnbQROOsCF5PiHEg4UNKVwLOIP6suYDfmXpjCtSugwHiiFmybpn4kFjjPXLrb5R222tU
        1HCFBEbSCvWlfb+OhTjmgG2Mf2cJdOkSkFXnT69dw8N5HV4k3lJpKrrO9HaMaD187PCHP3
        JgQ7D672aWmPjHL6o3EYVcNqME42sOycHYqHhosu2Sx8e2X8zwpd+Itz/XTD5C2IWjI2QN
        DXa7+2bUQtktot89T5lsZTqZdc2LoMnsAxrQoLjhpc3+fJZ4IidbRSIJwzNk/g==
Subject: Re: [PATCH 2/2] mac802154: use dev_addr_set() - manual
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alex.aring@gmail.com, linux-wpan@vger.kernel.org
References: <20211019163606.1385399-1-kuba@kernel.org>
 <20211019163606.1385399-2-kuba@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <e6fc36f7-4c99-1a2d-355c-a40a97491050@datenfreihafen.org>
Date:   Wed, 20 Oct 2021 23:16:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211019163606.1385399-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 19.10.21 18:36, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Tested on my local ieee802154 setup without showing problems.

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
