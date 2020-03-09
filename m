Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DE817DD3C
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgCIKRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:17:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:37902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCIKRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 06:17:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 067AFAAC7;
        Mon,  9 Mar 2020 10:17:07 +0000 (UTC)
Message-ID: <1583749022.17100.5.camel@suse.com>
Subject: Re: [PATCH] cdc_ncm: Implement the 32-bit version of NCM Transfer
 Block
From:   Oliver Neukum <oneukum@suse.com>
To:     Alexander Bersenev <bay@hackerdom.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 09 Mar 2020 11:17:02 +0100
In-Reply-To: <20200305203318.8980-1-bay@hackerdom.ru>
References: <20200305203318.8980-1-bay@hackerdom.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, den 06.03.2020, 01:33 +0500 schrieb Alexander Bersenev:
> The NCM specification defines two formats of transfer blocks: with 16-bit
> fields (NTB-16) and with 32-bit fields (NTB-32). Currently only NTB-16 is
> implemented.
> 
> This patch adds the support of NTB-32. The motivation behind this is that
> some devices such as E5785 or E5885 from the current generation of Huawei
> LTE routers do not support NTB-16. The previous generations of Huawei
> devices are also use NTB-32 by default.
> 
> Also this patch enables NTB-32 by default for Huawei devices

Hi,

do you really see no other option but to make the choice with yet
anothet flag? The rest of the code looks good to me.

	Regards
		Oliver

