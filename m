Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5898311F38F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 19:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfLNSo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 13:44:57 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45518 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfLNSo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 13:44:57 -0500
Received: by mail-ed1-f67.google.com with SMTP id v28so1775352edw.12
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 10:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OEIB7oLXgpTe7AAg95h3XtHjzBP6TZ27uDW1rkD10Jk=;
        b=s/ydYa5jaCJwTGSwbgK06wNLiifkfBn6JaXvAygHxjRErCZTMN+qQZG/tLB07kkWuc
         KuN4xeLWTpc4LcY9JERCcSDlwDLVIb9yZ2GZTdDmjjzPjLb5LnmjkpHk5w3t2G/9R93v
         fQ1DsBEbyId9trxOXKyUJVDGtXoueV5qT/1UWmyme7RXDZ23n8l6f0Iv6k7tUjoAnPg6
         87MwvL1a5ltydtzINYwGqankIwLNYIQiXEDPM19fvrKkEXTH9WcmIHv3SfyHZt2JTQ2j
         r1xZ92B1FlqWtcDt7DLFgdDE/3iGgCbXAdG6MqXXVXqPDsyQnTTXcjEVc2jguDvg8Aus
         b8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OEIB7oLXgpTe7AAg95h3XtHjzBP6TZ27uDW1rkD10Jk=;
        b=ax8opGDl39uHX8vE/n6bsFkH09IyjF3zKlIRC6pDDjlAsjU6a5BopWj3uMiFBrnvC4
         /gZHYtQEC3yR9ZbGl+jZrgZXDDe8Z1zlI4VnGE6m8ii/4K4KYrYojNTTrAd6/avbT9j6
         GAh9wkeLy9VZi3yDNkqSblRNeSFHT9MCF7f9DgV+IOsJwG5XcbrMk9k6Ur8BZFsss7Ep
         SzM//WLjfP8Vw5yE1A61ll2AI/uOSR6oLBtuWvaZZ94J7uernqHSCqnwScrg/YtEqTQF
         uEIxdulaBc/6ijIhsK2z5myPoZEXvR8eCCy95foyyTI9DGPSeac+s7Ce/qiau7Dem5Kw
         399A==
X-Gm-Message-State: APjAAAVRh1wv564v69cYXu1xW30yBw12JBlRb09yvwR5aSbNgHqqK7Q5
        CM5Ept8JhGdd7v7cMk3XG9nQH/CCOCwYvCcNtYVbfA==
X-Google-Smtp-Source: APXvYqyalhdwrUmhq8UgoAzYy8OuuKhTmrGyJsnEr7twLoBSEg9CNqtdvWeO4UscbrEP0npYhYztHnm69Tbr6/Zo+A4=
X-Received: by 2002:a50:c048:: with SMTP id u8mr22968967edd.226.1576349095578;
 Sat, 14 Dec 2019 10:44:55 -0800 (PST)
MIME-Version: 1.0
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-2-git-send-email-tom@herbertland.com> <20191006130205.3ccn4ap7pkm3dtxq@netronome.com>
In-Reply-To: <20191006130205.3ccn4ap7pkm3dtxq@netronome.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 14 Dec 2019 10:44:43 -0800
Message-ID: <CALx6S35SpmROZkco+1FF3UgW-U3t3RrM84XU2CyZg5Sv2aWO6A@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 1/7] ipeh: Create exthdrs_options.c and ipeh.h
To:     Simon Horman <simon.horman@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 6:02 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Thu, Oct 03, 2019 at 02:57:58PM -0700, Tom Herbert wrote:
> > From: Tom Herbert <tom@quantonium.net>
> >
> > Create exthdrs_options.c to hold code related to specific Hop-by-Hop
> > and Destination extension header options. Move related functions in
> > exthdrs.c to the new file.
> >
> > Create include net/ipeh.h to contain common definitions for IP extension
> > headers.
> >
> > Signed-off-by: Tom Herbert <tom@herbertland.com>
>
> Hi Tom,
>
> I'm not entirely clear on the direction this patchset it going in -
> I assume its part of a larger journey - but in isolation this
> patch seems fine to me.

Hi Simon,

Sorry for the delayed response.

The overall direction here is to make extension headers as well as
TLVs more usable and better performance. This patch isolates extension
headers and TLV processing as a common facility which will allow
multiple uses (SR TLVs can use this, IPv4 DestOpt and HBH options, and
potentially other use cases of TLVs). Also, this set allows
non-privileged applications to set DO and HBH options with correct
permissions per option type and also validates options are properly
formed per some rules (for instance the length of an option being set
by an application can be validated that it falls in a required range).

Future patch sets will allow setting specific HBH and DO options on a
socket (as opposed to all or nothing currently done). Experimental
options will be allowed following the same format used for TCP
experimental options. I'd also like to add ability to parse options in
flow dissector and probably a BPF helper for XDP.

>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
>
