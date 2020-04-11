Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87471A5265
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 15:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgDKNq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 09:46:57 -0400
Received: from canardo.mork.no ([148.122.252.1]:33959 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgDKNq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 09:46:57 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 03BDktna028880
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 11 Apr 2020 15:46:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1586612816; bh=WvUsLvPkZ9By/1v8OfMvd5JPtGMgPIXHKEwMgdKcyzc=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=T7zpC0FJmQ5VoD5jt5p84pH+URxNah9Lq9KJEHDfdM7T5byT7whBsF7R91tOvnUL9
         66zVebcLIhPlxdcJ6LqesCYlbXGPM7GiWuNAqCj1SvLzoJ6O9hy9+ueOM8zZB0nPRJ
         GCZZk6D2092X3956+YdBDSNp7tiAId+pYPpaiSXQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1jNGTH-00011t-Em; Sat, 11 Apr 2020 15:46:55 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org
Subject: Re: [PATCH net,stable] qmi_wwan: add Huawei E1820
Organization: m
References: <20200411133941.3806-1-bjorn@mork.no>
Date:   Sat, 11 Apr 2020 15:46:55 +0200
In-Reply-To: <20200411133941.3806-1-bjorn@mork.no> (=?utf-8?Q?=22Bj=C3=B8r?=
 =?utf-8?Q?n?= Mork"'s message of
        "Sat, 11 Apr 2020 15:39:41 +0200")
Message-ID: <87blnyp228.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.1 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't apply.

I didn't notice this until I sent the patch.  But we already have the
device in the table, using interface number based matching:

	{QMI_FIXED_INTF(0x12d1, 0x14ac, 1)},	/* Huawei E1820 */

That should be good enough since the interface number is matching the
02/06/ff function.


Bj=C3=B8rn

