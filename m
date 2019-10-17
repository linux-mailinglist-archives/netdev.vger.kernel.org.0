Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483F5DAC86
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406466AbfJQMnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 08:43:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39947 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406411AbfJQMnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 08:43:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id o28so2178103wro.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 05:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HGYfQMOQQ/Llw7JM+7jrZqk8jvWFbqivJs1N/X/ktYU=;
        b=1W6T+By6Fyb2jmC1zIN29lxvN1RfimvyqGZm/IyNd0V+jAhEnMuR3HyZpQgzrmOhLk
         PVRFTAfV/ZKXqr6U/08O1Ez3u3mVXh5UF45EOmJyN3i4IzE3ozHnHpbxebhjZ94shBvL
         gHXflbn54dpLGUVRAM6N1AIiKogkN2aPAmJCtXER0fMyKruwAyjCtnCp3Rdk4VX76zV8
         vxUCyNaqnutYi9qbxamM5qop4YUgQPt/9Tt21OPAYxz34RRWnzsq5SkxwtK6D7YJZOTA
         WmDUDbMaLCyxAVbKdVFhHQMpTO7XA2cyDMEkk1fNYHBI9fnGNSx8oQhGeCqkQaUCwJaf
         ML8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HGYfQMOQQ/Llw7JM+7jrZqk8jvWFbqivJs1N/X/ktYU=;
        b=FWHYJk1xG76fevFY63AzpOa1GKBu847ZfvXtGbrILcofoebLeEk/pxtpQLfj+2HS2Q
         kedwdllrAzaVvZ5PEVmr1El9u4OnE4pQZbDO99YELzjiTL3taiO/xiZLcrGhrdXaa1ee
         TBDUQH9zI7yFbkz5fzCyYJ9LyS/o4ZmPb4VtunZ0TflQvUgBQcKIXv5FDq4YiMEpbZU/
         byRLrOt4XLrXlkIlSzodc5v7WN5V0O1EpPnQsF8Dfdxv48nbkJJhkuNqZw8vHno5htQE
         oL3z4T6ZCS33qanuZrT+4/9ENoZiXrWnwLGBdnW3gsKMnPinz3UHN7SYs6o7pWQ3Px+d
         /RZg==
X-Gm-Message-State: APjAAAVklBs9B9Hg0VIoOiMg2gb375cytnkjkdBuAKH0u8hoyziNsa4O
        mr8IHXaEov9h/3E4w2Xop6cI+Q==
X-Google-Smtp-Source: APXvYqxSTrTbdDOJVZ/NSpsLlPLKMh5bomXVvJWF0PlOY6wiEaCsHR6FF/GB5VdIRYS1B4NMgrdXsA==
X-Received: by 2002:a05:6000:1190:: with SMTP id g16mr2819078wrx.133.1571316182250;
        Thu, 17 Oct 2019 05:43:02 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id k8sm576756wrg.15.2019.10.17.05.43.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Oct 2019 05:43:01 -0700 (PDT)
Date:   Thu, 17 Oct 2019 14:43:01 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        linux-kernel@lists.codethink.co.uk,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RFC: Bluetooth: missed cpu_to_le16 conversion in
 hci_init4_req
Message-ID: <20191017124300.fktzd27yy2t7gcqx@netronome.com>
References: <20191016113943.19256-1-ben.dooks@codethink.co.uk>
 <20191016122022.kz4xzx4hzmtuoh5l@netronome.com>
 <BFA3CB11-5FD8-4BD8-9DDA-62707AB84626@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BFA3CB11-5FD8-4BD8-9DDA-62707AB84626@holtmann.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 08:42:48PM +0200, Marcel Holtmann wrote:
> Hi Simon,
> 
> >> It looks like in hci_init4_req() the request is being
> >> initialised from cpu-endian data but the packet is specified
> >> to be little-endian. This causes an warning from sparse due
> >> to __le16 to u16 conversion.
> >> 
> >> Fix this by using cpu_to_le16() on the two fields in the packet.
> >> 
> >> net/bluetooth/hci_core.c:845:27: warning: incorrect type in assignment (different base types)
> >> net/bluetooth/hci_core.c:845:27:    expected restricted __le16 [usertype] tx_len
> >> net/bluetooth/hci_core.c:845:27:    got unsigned short [usertype] le_max_tx_len
> >> net/bluetooth/hci_core.c:846:28: warning: incorrect type in assignment (different base types)
> >> net/bluetooth/hci_core.c:846:28:    expected restricted __le16 [usertype] tx_time
> >> net/bluetooth/hci_core.c:846:28:    got unsigned short [usertype] le_max_tx_time
> >> 
> >> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> >> ---
> >> Cc: Marcel Holtmann <marcel@holtmann.org>
> >> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> Cc: linux-bluetooth@vger.kernel.org
> >> Cc: netdev@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >> ---
> >> net/bluetooth/hci_core.c | 4 ++--
> >> 1 file changed, 2 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> >> index 04bc79359a17..b2559d4bed81 100644
> >> --- a/net/bluetooth/hci_core.c
> >> +++ b/net/bluetooth/hci_core.c
> >> @@ -842,8 +842,8 @@ static int hci_init4_req(struct hci_request *req, unsigned long opt)
> >> 	if (hdev->le_features[0] & HCI_LE_DATA_LEN_EXT) {
> >> 		struct hci_cp_le_write_def_data_len cp;
> >> 
> >> -		cp.tx_len = hdev->le_max_tx_len;
> >> -		cp.tx_time = hdev->le_max_tx_time;
> >> +		cp.tx_len = cpu_to_le16(hdev->le_max_tx_len);
> >> +		cp.tx_time = cpu_to_le16(hdev->le_max_tx_time);
> > 
> > I would suggest that the naming of the le_ fields of struct hci_dev
> > implies that the values stored in those fields should be little endian
> > (but those that are more than bone byte wide are not).
> 
> the le_ stands for Low Energy and not for Little Endian.

Thanks, in that case I have no objections.
