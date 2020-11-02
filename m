Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34B42A2737
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 10:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgKBJlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 04:41:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:50976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728354AbgKBJlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 04:41:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604310062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hIRIGrmRocVriYBb0fyOhzMtWmG1OjA+MkhB2ntl4lM=;
        b=ucSDb1lur32HQbkq3S66LJvOadSLfHnH/nr6NwbP9CIo/nOqDSdrPxCpkxf+161nw5azcY
        +U0Wy8kLSnShIRPFFbKNMQj0tz/JU5QC24plygLJt3R+guhC7mPg6L6mCrxlGTsyPObxwN
        nxurDmWnsKigjM2oUTHzp8DvzSPiRqY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E000BAE65;
        Mon,  2 Nov 2020 09:41:01 +0000 (UTC)
Message-ID: <11476cd1da8b63f75d39bd5b8e876ad3968a1903.camel@suse.com>
Subject: Re: [PATCH v3] net: usb: usbnet: update __usbnet_{read|write}_cmd()
 to use new API
From:   Oliver Neukum <oneukum@suse.com>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Date:   Mon, 02 Nov 2020 10:40:54 +0100
In-Reply-To: <20201031213533.40829-1-anant.thazhemadam@gmail.com>
References: <20201029132256.11793-1-anant.thazhemadam@gmail.com>
         <20201031213533.40829-1-anant.thazhemadam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Sonntag, den 01.11.2020, 03:05 +0530 schrieb Anant Thazhemadam:
> Currently, __usbnet_{read|write}_cmd() use usb_control_msg().
> However, this could lead to potential partial reads/writes being
> considered valid, and since most of the callers of
> usbnet_{read|write}_cmd() don't take partial reads/writes into account
> (only checking for negative error number is done), and this can lead to
> issues.
> 

Hi,

plesae send this as a post of its own. We cannot take a new set
as a reply to an older set.

	Regards
		Oliver


