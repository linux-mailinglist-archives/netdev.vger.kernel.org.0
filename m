Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B348711FD2A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 04:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLPDNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 22:13:14 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35535 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfLPDNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 22:13:13 -0500
Received: by mail-yw1-f65.google.com with SMTP id i190so2016931ywc.2
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 19:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=greyhouse-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=opoxV1PtP3YLVdyiPbIsCA9HuzyX8MnUl2LumAuz69M=;
        b=xEeJJQrxBRpHXJSbkcN8o3QlTmjOPHFi+JHq9gi2R9NdhCnLwxx+VlBR9WCKg/cemH
         Px3HB0yqugd9LQe7iU5cwc4ylihc6YX2Z58o0dgbiG8vz4+aINkA6lNPkifWOXVi90TX
         KEaSmeIcf+RYl2zf+7frhbuOTyMrlWNyZzF8qjHGZXZsaFzFRhbm7BZ6x47CAKJUUDWh
         qpip1O1UoaijDCYWQ7XRta2g2Cc3TFWyW+2tqRxrvR8tr7cBhdVvvpVqtogzzf0eIpbX
         WDAd6rm8CAKY+z/2Ol/R95QI98wFYLlpBrjgU4VcQPslKlbBJlPHtTpg9uhWw+E2vWLA
         MFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=opoxV1PtP3YLVdyiPbIsCA9HuzyX8MnUl2LumAuz69M=;
        b=RDz8HV4FMZVV2k/jL/mKVGjuvzRtm4qBefu6QNRDLCSdQCq11vytxeLfIgrkXLs9br
         72QTY7qURqAXn3Q3AA1y9xIivlP41Ak7U+/Eznkc8XX+YOELnDDB2uH6ven+1n/7XDLL
         6bJe/LqUUIbCQM9XZULjiTrRqIcTPttbZsXwNo0rLBkbSQBhCv9vQDa+KOneqkIOfeAT
         0x/1oxuhJ1wb+gvR2N7FP2PbLa45BPqM9VOXl9vdNVCS8DpcLo64326LeoI+cDBtYqCh
         ZDFVCSCBquvBh1U/ns3fART/xVbwAD0pWQ5NQBrLjGeZWnKg1h3HjoLawrT7aWQP7CEq
         JbNA==
X-Gm-Message-State: APjAAAVVcY1jtP4YmKJ14Aa11d/pwHGvFcLwT19ciq2ra4S/KthapCxS
        XDHKHAR4bhrFzbrXbBZuwzdLfA==
X-Google-Smtp-Source: APXvYqxTApNbJ/HJ5gA4pxAJljx9TwQOA8125iKSS3GXlONHJEYntOFCvnKq3Z5vHOAPD5wKMOsNTw==
X-Received: by 2002:a81:70a:: with SMTP id 10mr16721878ywh.362.1576465992702;
        Sun, 15 Dec 2019 19:13:12 -0800 (PST)
Received: from C02YVCJELVCG.greyhouse.net (104-190-227-136.lightspeed.rlghnc.sbcglobal.net. [104.190.227.136])
        by smtp.gmail.com with ESMTPSA id e63sm7722955ywd.64.2019.12.15.19.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 19:13:12 -0800 (PST)
Date:   Sun, 15 Dec 2019 22:13:08 -0500
From:   Andy Gospodarek <andy@greyhouse.net>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andy Roulin <aroulin@cumulusnetworks.com>,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] bonding: move 802.3ad port state flags to
 uapi
Message-ID: <20191216031308.GA29928@C02YVCJELVCG.greyhouse.net>
References: <1576103458-22411-1-git-send-email-aroulin@cumulusnetworks.com>
 <20191214131809.1f606978@cakuba.netronome.com>
 <1076ce41-2cd5-e1d9-9b9f-ddc01385d343@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1076ce41-2cd5-e1d9-9b9f-ddc01385d343@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 08:10:15PM -0700, David Ahern wrote:
> On 12/14/19 2:18 PM, Jakub Kicinski wrote:
> > On Wed, 11 Dec 2019 14:30:58 -0800, Andy Roulin wrote:
> >> The bond slave actor/partner operating state is exported as
> >> bitfield to userspace, which lacks a way to interpret it, e.g.,
> >> iproute2 only prints the state as a number:
> >>
> >> ad_actor_oper_port_state 15
> >>
> >> For userspace to interpret the bitfield, the bitfield definitions
> >> should be part of the uapi. The bitfield itself is defined in the
> >> 802.3ad standard.
> >>
> >> This commit moves the 802.3ad bitfield definitions to uapi.
> >>
> >> Related iproute2 patches, soon to be posted upstream, use the new uapi
> >> headers to pretty-print bond slave state, e.g., with ip -d link show
> >>
> >> ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>
> >>
> >> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
> >> Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> > 
> > Applied, I wonder if it wouldn't be better to rename those
> > s/AD_/BOND_3AD_/ like the prefix the stats have. 
> > But I guess it's unlikely user space has those exact defines 
> > set to a different value so can't cause a clash..
> > 
> 
> I think that would be a better namespace now that it is in the UAPI.

I agree that it would be nuch nicer.  I never really liked the 'AD'
usage as an abbreviation for 802.3ad.

