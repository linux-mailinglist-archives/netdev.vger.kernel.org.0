Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E58B7B63
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732346AbfISN7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732329AbfISN7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 09:59:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1E8A20665;
        Thu, 19 Sep 2019 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568901560;
        bh=I8osdBr5rK8/FGiX5xKVgPYs/R2ZYcecd+s4/UF9w7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8OD1gi3nEkTcNUJXlI6jOI0AXpXmj5vr0wFr4lUW9cV/3FEkMLfxB1hYO9dPEKHm
         gem2FmhUVREnBHtoUT44ZUBnM2Khz7+40EO3x1jDJCu1W6YYQLVYOdOd92xjzNuT/u
         1xPPixqNnXvMfZv8eLmwekOhdmVU7OIqADqoj3MU=
Date:   Thu, 19 Sep 2019 15:59:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Le Goff <David.Legoff@silabs.com>
Subject: Re: [PATCH v2 20/20] staging: wfx: implement the rest of mac80211 API
Message-ID: <20190919135918.GA3853501@kroah.com>
References: <20190919135220.30663-1-Jerome.Pouiller@silabs.com>
 <20190919135220.30663-21-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190919135220.30663-21-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 01:52:42PM +0000, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

I can not take patches without any changelog text :(


