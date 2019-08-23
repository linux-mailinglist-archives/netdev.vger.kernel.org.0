Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565939B657
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405146AbfHWSp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:45:57 -0400
Received: from canardo.mork.no ([148.122.252.1]:53893 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730788AbfHWSp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 14:45:57 -0400
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2019 14:45:55 EDT
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x7NIY98R010591
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 23 Aug 2019 20:34:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1566585251; bh=rhbGCmlboXmRguY9Y37vGEPWSnNoT7bk5MSyh7OrhWA=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=CXRcMehx+XnXe/Nzi0Ss84Q3Ouhy5OUMpObO5v5EtHxnzHHzPSnWspr7JGSBxbeoq
         NGmQziZTCGpDQsNI5sUC5YhUztdPVnum/xkOP3e5EK6exw3D0lSUdP7fcz4bochtnJ
         kSK9qD6Tc76twkYhKEU2lYOIii0Z38q0xnbhHKfg=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1i1EO0-0001F4-I0; Fri, 23 Aug 2019 20:34:08 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     <Charles.Hyde@dellteam.com>
Cc:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <Mario.Limonciello@dell.com>,
        <oliver@neukum.org>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: Re: [RFC 3/4] Move ACPI functionality out of r8152 driver
Organization: m
References: <1566339738195.2913@Dellteam.com>
Date:   Fri, 23 Aug 2019 20:34:08 +0200
In-Reply-To: <1566339738195.2913@Dellteam.com> (Charles Hyde's message of
        "Tue, 20 Aug 2019 22:22:18 +0000")
Message-ID: <87mufz20kf.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<Charles.Hyde@dellteam.com> writes:

> This change moves ACPI functionality out of the Realtek r8152 driver to
> its own source and header file, making it available to other drivers as
> needed now and into the future.  At the time this ACPI snippet was
> introduced in 2016, only the Realtek driver made use of it in support of
> Dell's enterprise IT policy efforts.  There comes now a need for this
> same support in a different driver, also in support of Dell's enterprise
> IT policy efforts.

Yes, and we told you so.


Bj=C3=B8rn
