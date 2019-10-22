Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE86DFC40
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 05:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387557AbfJVDg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 23:36:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36898 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387437AbfJVDg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 23:36:29 -0400
Received: by mail-pg1-f196.google.com with SMTP id p1so9083094pgi.4
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 20:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cVy7yShhC8zq//OaJuW+5FNqcWb0Q3J+anwfZn0q1yg=;
        b=wjdFPrS99Qew3fagBBczM4Wsds99NvhHTvVot1tWpUCWOdm4Hb/cu2O0HCzHA6/Mjm
         Qj0rVanAt/5WVnqIysEkKdBdVyMSeZ5fuXYcWdDeKw1IFAdR5tLLCksEqmk9fI34l504
         dy1oWssBXD6FZJvLY3ed/jixqln22tD36CDBE9JE2Vh0hvY92aGD34wxlralqIMbrEMM
         mdiz1lounw/ppXFAiOdI6MamLDwlo2KhkaaxVryulCVC3qpS4Gw3DrJkXHCKUXpV/fXP
         8AAIeH4blNuEy1Y9AebZDUHfqqdv5ZJrdeppRFHXuU1ue+NpHMpWf69DyguL/PO0gjm/
         nTpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cVy7yShhC8zq//OaJuW+5FNqcWb0Q3J+anwfZn0q1yg=;
        b=RGk8HQQDoJ6yqSsCEkNcPbGlf5dtu1sj47SZC5qvzO/HXIIwy9JwkA7rIW90JTJPo2
         qq7fK7ixmIMrzP2u50Ibxii1zCSCWh14NfeAEEd1buqNnFE831/Flw7shYzaHhLlQ4lM
         TM877kX6j77do5eWNNo8b5Rj8waBb/1/zbE+2jyQGxW8/HDoNLBjBjKiQ9Uf2drawaLB
         CcYhrpHAsrio1mxVqPjlxHtp7/kVuRUaLbf8AZfxLkHN3EfflJ0+tpABqLZzolkQ9Ea4
         p0hNq3vwsdA7Nwq7ZbCLXzi1K0zBIBb0qEOYntfz+Kay/cqULpeqOBuvj0pNfBPn8lxw
         yz8A==
X-Gm-Message-State: APjAAAWK2WRzm78n3I7tJJ39iWXsEmSXTzniQ946QvioV/Qe0YBNHIwl
        WrqA4iVJICwiiYaEkM8C/iPc6w==
X-Google-Smtp-Source: APXvYqxYNpB27E8snEB5dKY2A/L9yUso54sLY2ck5r6vDnSmXHGLHYCdPhWQJqD/GKCo12evJQUlHw==
X-Received: by 2002:aa7:838f:: with SMTP id u15mr1671720pfm.74.1571715388539;
        Mon, 21 Oct 2019 20:36:28 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id l23sm16094004pjy.12.2019.10.21.20.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 20:36:28 -0700 (PDT)
Date:   Mon, 21 Oct 2019 20:36:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>
Subject: Re: [PATCH net-next 4/4] r8152: support firmware of PHY NC for
 RTL8153A
Message-ID: <20191021203625.448da742@cakuba.netronome.com>
In-Reply-To: <1394712342-15778-334-Taiwan-albertk@realtek.com>
References: <1394712342-15778-330-Taiwan-albertk@realtek.com>
        <1394712342-15778-334-Taiwan-albertk@realtek.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 11:41:13 +0800, Hayes Wang wrote:
> Support the firmware of PHY NC which is used to fix the issue found
> for PHY. Currently, only RTL_VER_04, RTL_VER_05, and RTL_VER_06 need
> it.
> 
> The order of loading PHY firmware would be
> 
> 	RTL_FW_PHY_START
> 	RTL_FW_PHY_NC

Perhaps that's obvious to others, but what's NC? :)

> 	RTL_FW_PHY_STOP
> 
> The RTL_FW_PHY_START/RTL_FW_PHY_STOP are used to lock/unlock the PHY,
> and set/clear the patch key from the firmware file.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
