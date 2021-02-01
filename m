Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D62D30B1A3
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhBAUei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhBAUec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 15:34:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98CE964E9E;
        Mon,  1 Feb 2021 20:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612211631;
        bh=YbB8zbhMG18OcGdWvLx/HSeTnjJWEAJ0k9nKhQ2F0XQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uy2koLzW2WRGUAUIce1HfVOKiKHDCv2p3fhigkHJ5BDlkuGMQfAes1NL66aKC7l1r
         ZFOGYN1sWt18rzwtth4RVN9hnoAX7i6TdITve5WcGI3Rpq0S9lUyqPPPd+LS6z6+1F
         4qY2nVAPaVjh88cCybVguGBpFmnJbPLkq7R+T4+MmRFQtbO09sQombpqzW+2cQUzeh
         UZJoI2il1IiJmBynucTYODUZEexAiuaE5m1XdRgVodEQx8OHlIjZ7lwKwuTUq3a2CS
         DzljJ6sw6Wpj5q6xfy5PNjyxxtMEtwXAipycQzBZ43bWleZxKYimpjcyHS3YeVVA1/
         BzZifb6pvdRyA==
Date:   Mon, 1 Feb 2021 12:33:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Lowe <nick.lowe@gmail.com>
Cc:     Matt Corallo <linux-wired-list@bluematt.me>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
Message-ID: <20210201123350.159feabd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADSoG1vn-T3ZL0uZSR-=TnGDdcqYDXjuAxqPaHb0HjKYSuQwXg@mail.gmail.com>
References: <20201221222502.1706-1-nick.lowe@gmail.com>
        <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
        <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
        <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <69e92a09-d597-2385-2391-fee100464c59@bluematt.me>
        <CADSoG1vn-T3ZL0uZSR-=TnGDdcqYDXjuAxqPaHb0HjKYSuQwXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 20:23:51 +0000 Nick Lowe wrote:
> I personally tested with mainline and 5.10, but not 5.4

My preference would be to merge into net-next, and then do the
backport after 5.11 is released.
