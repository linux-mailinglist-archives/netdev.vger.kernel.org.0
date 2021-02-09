Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77B13153A7
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhBIQSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:18:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhBIQS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 11:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A399164EAA;
        Tue,  9 Feb 2021 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612887466;
        bh=8s1KqE1BtMsVcS0eFE+GfcmfIiylX5MpTsFIA3Ujqm4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eB0IaQ0eALLvtW5WHfGR4Rzo4ExGq/fcPp8QgdDnUwTfz1QQ086LtdN6rqFWTDhYV
         DmOnY/ISb1sC9mlZj+CHciHwX5jDMCYlL12N589mqpS5gLd3whOfiaCXvAiqcuV9Lg
         UZtsZLaUWZO7ZLc1ak9e4HnQ7tWBLfosE5JfPOnEjMXLVhMljv8yJgGvgiFtXPFICX
         H3nN8JUJLBeQYimZkHcd7k+CSdvvt2ImwPjboSQnXMGnwqr+exEQektudEmOPX53oO
         MqdfONg4b+jp1nXHiq8JxCh6SAF/f56HqcP/wAkBA7cbNDU29UrdGq5GLTTtpTZsru
         REXsPY9Fe1AWg==
Date:   Tue, 9 Feb 2021 08:17:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210209081744.43eea7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
        <20210113152625.GB30246@work>
        <YBGDng3VhE1Yw6zt@kroah.com>
        <20210201105549.GB108653@thinkpad>
        <YBfi573Bdfxy0GBt@kroah.com>
        <20210201121322.GC108653@thinkpad>
        <20210202042208.GB840@work>
        <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
        <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
        <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 10:20:30 +0100 Aleksander Morgado wrote:
> This may be a stupid suggestion, but would the integration look less a
> backdoor if it would have been named "mhi_wwan" and it exposed already
> all the AT+DIAG+QMI+MBIM+NMEA possible channels as chardevs, not just
> QMI?

What's DIAG? Who's going to remember that this is a backdoor driver 
a year from now when Qualcomm sends a one liner patches which just 
adds a single ID to open another channel?
