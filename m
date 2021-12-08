Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C67C46DDB9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238544AbhLHVnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:43:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54044 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbhLHVnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 16:43:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3047B822DB;
        Wed,  8 Dec 2021 21:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20650C00446;
        Wed,  8 Dec 2021 21:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638999581;
        bh=7FUEvofvc+6QUUkmMfaiQ+4CgoHOoxX7tWRkFyorGD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tHhT784ShmUxmZ+qnUE0EbLPO0qwghx/66ELcHb1a5eXlSiN8uK1bt7tvf4OgdafN
         IJE8fJY83R1jkd9mtE+AfslhLVCe2CEgKf2Vl0HagLYbf6whNc1IotfIShtotKOJq1
         ab6SXCpTD8dsgC+4UAKCEA/4eGeUZvRrre42Dp0CSG5jumdVU7W26f16v01/5Hbnyv
         tu6RPygqNOFq+U4NReQGVFSHLLHH6lN29Q4uYY+LKEqCAAcpuVTletXQUD/RxvBGPR
         TYdHe5hcV7vLfPpIbz0ABBdF6GR8FTC5QpJSAykeQFwcKhGaLwy+mxt2giaIAgsO/l
         th8wXLLyi3Z9w==
Date:   Wed, 8 Dec 2021 13:39:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joseph CHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 0/2] *** ADD DM9051 NET DEVICE ***
Message-ID: <20211208133940.3c152e4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211202204656.4411-1-josright123@gmail.com>
References: <20211202204656.4411-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Dec 2021 04:46:54 +0800 Joseph CHANG wrote:
> *** DM9051 is a SPI interface ethernet controller chip ***
> *** For a embedded Linux device to construct an ethernet port ***
> *** Fewer CPU interface pins is its advantage comapre to DM9000 ***
> *** It need only cs / mosi / miso / clock and an interrupt pin ***

No need for the *** markings in the subject and message body.

Please make sure to fix the dates on the patches, they are two weeks 
in the future.
