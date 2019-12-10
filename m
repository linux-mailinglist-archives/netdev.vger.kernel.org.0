Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92648117C35
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 01:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfLJANy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 19:13:54 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35572 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLJANy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 19:13:54 -0500
Received: by mail-pj1-f68.google.com with SMTP id w23so6609154pjd.2
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 16:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KLN1DYREPXJpHHYubJRCZWT4Wl8rGRaKmxfqjHjWjvk=;
        b=iwzzrNTlkY94RCl4TChdZktFq7Pjb6pT5dQseFy7qH0h/JLXalF6dHolaBGhxLQowT
         dhz8TdjxRX29eMgwexF1fgI4Dlu7dA21zBBPkUCSJ9ejdaYLt4WLnLR+fiyw03Y2Sp+i
         cRhJK+g+J5khXtcocNbBzQtmz0/UDXF0FJqizj5S/Y3cWDPkSUjYg9OXegRsjMXXZrKN
         PgsXyI/vAt0lNtWHzlJdHS8Bl8xDKpW+lnQnOylhE/ugKIdNnm5npTUXKnElwHpf0Ju/
         +XE2Z+YQvJVFA5mMUMyFmgFtvrX26pi/NGYuAduda4ekrD33xvogSecQOX4kf6DKr9gk
         FWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KLN1DYREPXJpHHYubJRCZWT4Wl8rGRaKmxfqjHjWjvk=;
        b=V7HFcsg6XI1bum2dx+mee1LSa/eFR0vt5AkVeHJlYv/xvdZ3wR515yY+hdbjBh1Rb7
         zVoMmzAKNS+wHM4+A199l9lPxZVpug0etrnySVJ5iSUdF3E5GK1ntxhubAr8Tj1vtIcE
         vbidU8XvVfS4C9o8jgOB7x1MLZnYwdKO+8IXYrMgs5nH7UvWj0+pmrihQFOjyEwkbBW3
         gdVA7/WW6cLsJiXqtJyp3hVVnDVsrCDVF37p/ymCfOxOjNe/u2p9MaDaYnlDJpVIhz4E
         rR32oTuSVzphX5yWdDP6QV/F4f77u6FOPInNzbVw1CQZVpWQRU5RB5w6waClh19M69Fk
         uL0Q==
X-Gm-Message-State: APjAAAWYJ9omA14f2pAR3+OK8WlKjtMdXkrW5n83wzao6XVdp+yEy+LB
        fjF9ETJz5hnENMV3wNaeWbXyGA==
X-Google-Smtp-Source: APXvYqyEr7qSAEmUoFhMYvvTlKzsQKOGd/nnPA/96ScLfk/tsc1jAzlLra/Rm5FbWQte47dauiP8hA==
X-Received: by 2002:a17:90b:3115:: with SMTP id gc21mr1994006pjb.54.1575936833824;
        Mon, 09 Dec 2019 16:13:53 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id in6sm468181pjb.8.2019.12.09.16.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 16:13:53 -0800 (PST)
Date:   Mon, 9 Dec 2019 16:13:45 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH iproute2 v2] iplink: add support for STP xstats
Message-ID: <20191209161345.5b3e757a@hermes.lan>
In-Reply-To: <20191209230522.1255467-2-vivien.didelot@gmail.com>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
        <20191209230522.1255467-2-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Dec 2019 18:05:22 -0500
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> Add support for the BRIDGE_XSTATS_STP xstats, as follow:
> 
>     # ip link xstats type bridge_slave dev lan5
>                         STP BPDU:
>                           RX: 0
>                           TX: 39
>                         STP TCN:
>                           RX: 0
>                           TX: 0
>                         STP Transitions:
>                           Blocked: 0
>                           Forwarding: 1
>                         IGMP queries:
>                           RX: v1 0 v2 0 v3 0
>                           TX: v1 0 v2 0 v3 0
>     ...

Might I suggest a more concise format:
	STP BPDU:  RX: 0 TX: 39
	STP TCN:   RX: 0 TX:0
	STP Transitions: Blocked: 0 Forwarding: 1
...
