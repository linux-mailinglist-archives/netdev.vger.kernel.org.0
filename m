Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0A2303C7E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392402AbhAZMGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392346AbhAZLW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 06:22:58 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913ACC061797;
        Tue, 26 Jan 2021 03:21:17 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l4MPK-00Bsxn-Ff; Tue, 26 Jan 2021 12:21:14 +0100
Message-ID: <e0eac0c0576c260ccdd849996805562167fcc009.camel@sipsolutions.net>
Subject: Re: [PATCH] staging: rtl8723bs: fix wireless regulatory API misuse
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ilan.peer@intel.com,
        Hans de Goede <hdegoede@redhat.com>
Date:   Tue, 26 Jan 2021 12:21:13 +0100
In-Reply-To: <YA/7BL3eblv1glZr@kroah.com>
References: <20210126115409.d5fd6f8fe042.Ib5823a6feb2e2aa01ca1a565d2505367f38ad246@changeid>
         <YA/7BL3eblv1glZr@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-26 at 12:20 +0100, Greg Kroah-Hartman wrote:
> 
> > Greg, can you take this for 5.11 please? Or if you prefer, since the
> > patch that exposed this and broke the driver went through my tree, I
> > can take it as well.
> 
> Please feel free to take it through yours, as I don't think I'll have
> any more staging patches for 5.11-final (or none have been sent to me
> yet), so this might be the fastest way in:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

OK, will do, thanks!

johannes

