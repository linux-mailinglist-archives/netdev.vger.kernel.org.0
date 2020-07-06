Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31D7215BDC
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgGFQeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbgGFQeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 12:34:03 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB3EC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 09:34:03 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d10so15538327pls.5
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 09:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TTsEAFWcnxMfZFyp41Z07lSFSufh05TNsufMCub+PsQ=;
        b=uOsc/IXKYtkHvHPl19X0rpljPeVh600JrZRZ306PfVEy81aDfUCJ6hKFtdxz6fu6++
         1igXhJI0lnskceredXbhqug2OQvXI5a5LXWrEK471Q8RfAHVQ4egyOV87gcKfKrma+Zi
         tGHSfkelQEHHDFZjQMat13ZiYzRHOKJrAn09WZ8hpwNABDGHCAkzeHG9GUuKZ4Z3jwz2
         Gd6yp+zHrKEtJdgeeSUtQT3AzUr8N79KZTlztZZrLYqDw9hzHIPWoEpNiE7d1KG1H7Gm
         waMDRzugvvs1zx6pTfSjBZL5mAM+71klK8l44Kr841XbN9DDM7f4RP3r+TwouKK6y+sO
         bOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TTsEAFWcnxMfZFyp41Z07lSFSufh05TNsufMCub+PsQ=;
        b=exOX4ogu0/6m0QErjVaLnKoEYylGZcAzkysyx4utKUI4rrGnmYtKi8VbUXjy59Z0m0
         jpY1GtI1flWwt1rqkresQLEOSJrhzeFxPndyGFWhX0HB+7EMvP7dtEituu072pTwtBmp
         kAlPvJr25ZZomsQ4sFhSIo0fnErOOW2QxjhvdQ4giSNoh7a04zJgFzOEzYdub03GLjbQ
         Kv9/DfL620N2q1jWyqOy+RpkyD9A5daVIKQd5SbRtNwN7D/giJoCoyQ+mZXBfN+kT3+r
         99w2ZJV8PdCYkaakydw98Gos4PJbHzPEg6mili5AFAD9H4ozOoB9SwCg4dhWt6qdrt5f
         LfFg==
X-Gm-Message-State: AOAM5311Ct3bx7MkjRciHa2NKffA8ZnkbbCFEBxIghPNEo4LxOrALxfX
        Y/z6ZxKWSKPAzL3nOqwQc8Nevg==
X-Google-Smtp-Source: ABdhPJxVe1GHqDS4nNYW/iqce0zNhM63qI6GQ4jrbqtDraVQ0f4p4o1QVQLM6AT8M/3sbbuzJp77OA==
X-Received: by 2002:a17:902:c24a:: with SMTP id 10mr36845153plg.82.1594053242590;
        Mon, 06 Jul 2020 09:34:02 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b82sm19041378pfb.215.2020.07.06.09.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 09:34:02 -0700 (PDT)
Date:   Mon, 6 Jul 2020 09:33:54 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
        jiri@mellanox.com, kuba@kernel.org, michael.chan@broadcom.com
Subject: Re: [PATCH v2 iproute2-next] devlink: Add board.serial_number to
 info subcommand.
Message-ID: <20200706093354.7dd0edc2@hermes.lan>
In-Reply-To: <20200706063450.GA2251@nanopsycho.orion>
References: <1593416584-24145-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200705110301.20baf5c2@hermes.lan>
        <20200706063450.GA2251@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jul 2020 08:34:50 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Sun, Jul 05, 2020 at 08:03:01PM CEST, stephen@networkplumber.org wrote:
> >On Mon, 29 Jun 2020 13:13:04 +0530
> >Vasundhara Volam <vasundhara-v.volam@broadcom.com> wrote:
> >  
> >> Add support for reading board serial_number to devlink info
> >> subcommand. Example:
> >> 
> >> $ devlink dev info pci/0000:af:00.0 -jp
> >> {
> >>     "info": {
> >>         "pci/0000:af:00.0": {
> >>             "driver": "bnxt_en",
> >>             "serial_number": "00-10-18-FF-FE-AD-1A-00",
> >>             "board.serial_number": "433551F+172300000",
> >>             "versions": {
> >>                 "fixed": {
> >>                     "board.id": "7339763 Rev 0.",
> >>                     "asic.id": "16D7",
> >>                     "asic.rev": "1"
> >>                 },
> >>                 "running": {
> >>                     "fw": "216.1.216.0",
> >>                     "fw.psid": "0.0.0",
> >>                     "fw.mgmt": "216.1.192.0",
> >>                     "fw.mgmt.api": "1.10.1",
> >>                     "fw.ncsi": "0.0.0.0",
> >>                     "fw.roce": "216.1.16.0"
> >>                 }
> >>             }
> >>         }
> >>     }
> >> }  
> >
> >Although this is valid JSON, many JSON style guides do not allow
> >for periods in property names. This is done so libraries can use
> >dot notation to reference objects.
> >
> >Also the encoding of PCI is problematic  
> 
> Well, besides board.serial_number, this is what we have right now...

Could you investigate JSON usage and decide what style to use.
The rest of iproute2 doesn't do it.
