Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90911222739
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgGPPiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbgGPPiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 11:38:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF3A32076A;
        Thu, 16 Jul 2020 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594913926;
        bh=G8Zl9gleHNiBCu55Nq4ydnX8h6+TThG4FtYGk0/Xj8U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zR+wH+XyGZYssehv5cG3L1nwEl/PJKISzTBnO/FYkqMvB9AgrnkVqacAuCefaVdIN
         RDbERc5UG8g+AGV5vMsmpaOQ4IDzndQw/z1JsGW/R+3loRuvhSEyiFvWvCGThsYZbc
         ZPTa/gSkzJZAwyVBUQZoV1jcUUHR+QRL1hI96+t4=
Date:   Thu, 16 Jul 2020 08:38:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Pisati <paolo.pisati@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests: net: ip_defrag: modprobe missing
 nf_defrag_ipv6 support
Message-ID: <20200716083844.709bad58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMsH0TQLKba_6G5CDpY4pDpr_PWVu0yE_c+LKoa+2fm2f4bjBQ@mail.gmail.com>
References: <20200714124032.49133-1-paolo.pisati@canonical.com>
        <20200715180144.02b83ed5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMsH0TQLKba_6G5CDpY4pDpr_PWVu0yE_c+LKoa+2fm2f4bjBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 09:23:12 +0200 Paolo Pisati wrote:
> On Thu, Jul 16, 2020 at 3:01 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Any reason you add this command before set -e ?
> >
> > It seems we want the script to fail if module can't be loaded.  
> 
> Cause if CONFIG_NF_DEFRAG_IPV6=y, the script would unnecessarily fail.

I don't think modprobe fails when code is built in.

$ sudo modprobe pstore
$ echo $?
0
$ grep CONFIG_PSTORE= /boot/config-5.7.8-200.fc32.x86_64
CONFIG_PSTORE=y
$ lsmod | grep pstore
$
