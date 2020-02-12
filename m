Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED99115A675
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgBLKeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:34:21 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45754 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgBLKeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:34:21 -0500
Received: by mail-ed1-f65.google.com with SMTP id v28so1810007edw.12
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 02:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dR3hFTk26Srd39qvECOXy0ZWbUr62kuG7e5W0dgW6u0=;
        b=P9qwPwH26fn18YLxCQ2RjFpFbXFf8vGfj5+6A3pfXTQI5CNBTjiLGSJFvRM1zPO9D/
         LIHtVGu4TsBzqetTtO0Je8SDTsEE3CXxZx4SKSk2/svCpQN3PpoUr5nPhDggjhykSZTk
         O6gaazmGnRE1wF/kV+IhzYg/W+hu2g+mcTrHDVgrMUmnQd7gxfwyXEcNCDuQI/hP8nAI
         XzRj7yad8eX4DqpkLH8/1/SkX4J2wcUkBUGPvTBzpR8KCtc2PvNS09Ychi/HoCXO6q3w
         LnvOUK6NvyCbzoLuSjWyRDK3+su+ZlYlaIY0x9iurL4Fq+aP7c13JZA4xSgtMvwRI/sl
         xdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dR3hFTk26Srd39qvECOXy0ZWbUr62kuG7e5W0dgW6u0=;
        b=H4WcOlwK06AnUkYkjg5GM0VzJOngBQWXBb5YHSr+HUbhgqZ878P1qCo2EIlX/xS19g
         JFEU9ZM9K7t6us0ShdICVn6gI1nlNhSLM7XdnxOP0axd4WNF5WZ8CyUZtJi5JPywJrw3
         UB/XTDOywKI9ua1hIoqwoBD24W7jFQCcdwz8uTR+2RWrcBTpFIm491E95vWD0vFyWEO1
         yF+fIgxtvXuG3UTPCP3nozjQepvTMCYCqqjDPrZhtWqF10oRMXOO7MJiVw6y8cKgXd0v
         jaEjRG4NFnp7hDaPUKY14GkRJU82YE1GO9ria/0xegLynxpC2zT3x2xqN6QJWb8TSdq8
         SPnA==
X-Gm-Message-State: APjAAAVijNH7zsV3C/Y84nliXrLesGFQpUehKUcJT6NaSdF593JL2rO5
        ZWSwR1BqTyGrsAWopdVhB2r10AMl2EN3nmRVd88=
X-Google-Smtp-Source: APXvYqwB1n0eZyertDSMqml+fSnb/OMBxm2Ksh7z1dYxz3L3kUifPDMfqQzdeLjpq3tyjqU4m2hYTUdiwQ6uK7AG8zg=
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr10652084ejj.184.1581503659153;
 Wed, 12 Feb 2020 02:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20200211045053.8088-1-yangbo.lu@nxp.com> <20200211.170635.1835700541257020515.davem@davemloft.net>
 <AM7PR04MB68852520F30921405A717B6CF81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
In-Reply-To: <AM7PR04MB68852520F30921405A717B6CF81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 12 Feb 2020 12:34:08 +0200
Message-ID: <CA+h21hr+dE1owiF-e81psj3uKgCRdeS+C_LbFdd_ta91TS+CUA@mail.gmail.com>
Subject: Re: [PATCH] ptp_qoriq: add initialization message
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yangbo,

On Wed, 12 Feb 2020 at 12:25, Y.b. Lu <yangbo.lu@nxp.com> wrote:
>
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > Behalf Of David Miller
> > Sent: Wednesday, February 12, 2020 9:07 AM
> > To: Y.b. Lu <yangbo.lu@nxp.com>
> > Cc: netdev@vger.kernel.org; richardcochran@gmail.com
> > Subject: Re: [PATCH] ptp_qoriq: add initialization message
> >
> > From: Yangbo Lu <yangbo.lu@nxp.com>
> > Date: Tue, 11 Feb 2020 12:50:53 +0800
> >
> > > It is necessary to print the initialization result.
> >
> > No, it is not.
>
> Sorry, I should have added my reasons into commit message.
> I sent out v2. Do you think if it makes sense?
>
> " Current ptp_qoriq driver prints only warning or error messages.
> It may be loaded successfully without any messages.
> Although this is fine, it would be convenient to have an oneline
> initialization log showing success and PTP clock index.
> The goods are,
> - The ptp_qoriq driver users may know whether this driver is loaded
>   successfully, or not, or not loaded from the booting log.
> - The ptp_qoriq driver users don't have to install an ethtool to
>   check the PTP clock index for using. Or don't have to check which
>   /sys/class/ptp/ptpX is PTP QorIQ clock."
>
> Thanks.

How about this message which is already there?
[    2.603163] pps pps0: new PPS source ptp0

Thanks,
-Vladimir
