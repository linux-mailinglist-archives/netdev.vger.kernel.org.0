Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E773706F8
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 12:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhEAKuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 06:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhEAKuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 06:50:44 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73214C06174A;
        Sat,  1 May 2021 03:49:54 -0700 (PDT)
Received: from miraculix.mork.no (fwa183.mork.no [192.168.9.183])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 141AnfBm018840
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 1 May 2021 12:49:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1619866182; bh=DF2tGaWWflmbYZU2D/1JVrwQhqqAwzVUc39vUNXXikI=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=NGq+8+ekaqVCmMXqVEXQE6nRhkNuBxqifmEkLQN+o1Nl1Q2I7T6H+byEDmGfXitsz
         tYnaZjXDrMhqIX0324tOsozylEmoXQ6WX0NSyMbH7jNQyW//daVpsc3kSc7VnqNqn/
         PVteZhQ/hJipMplyH5eXgOw4Pz9n7UjI4jy0tYC4=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1lcnBs-001Usu-P9; Sat, 01 May 2021 12:49:40 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, kuba@kernel.org
Subject: Re: [RFC net-next 2/2] usb: class: cdc-wdm: WWAN framework integration
Organization: m
References: <1619777783-24116-1-git-send-email-loic.poulain@linaro.org>
        <1619777783-24116-2-git-send-email-loic.poulain@linaro.org>
        <bf02f5ecf84b7eaaa05768edd933a321f701e79f.camel@suse.com>
Date:   Sat, 01 May 2021 12:49:40 +0200
In-Reply-To: <bf02f5ecf84b7eaaa05768edd933a321f701e79f.camel@suse.com> (Oliver
        Neukum's message of "Fri, 30 Apr 2021 12:39:29 +0200")
Message-ID: <87a6pek9tn.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com> writes:

> This absolutely makes sense,

+1

Thanks for working on this.


Bj=C3=B8rn
