Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2A082A19
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 05:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbfHFDqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 23:46:45 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38586 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbfHFDqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 23:46:44 -0400
Received: by mail-pf1-f181.google.com with SMTP id y15so40726823pfn.5
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 20:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vtff4Fyy/X+zK16oko5L4cb2bhj+IH/p2iuCVMyodUM=;
        b=Neyk53x7zsMSwY7//U64rDW7xhNT1Iqd7J0Mx0m0t5w6Gm4oEsfLz7GD8nWYdqFWs4
         ElSTxB8yFEeSeP0GHen1Y2ZMo0S86PlbioVRu+T06QluKPGwmaMHiaUoxD+icqayuubn
         e5Wy60g9bp923uE/9WZT2wXoTpNLj0ZRCCdRb2k5Ag+0qggZBQZDybszg9Dp5b+NIzfh
         rPA7nt+30l1uCwf2lW+uIqhEjvc+hSShUvBgIUwNDuE9sznCHvFUGgZN4X2jamRMMRcV
         eCl5KRg9CCsLFIZBp0Pp0+j8uU8Vm+dFFO0wG6jmvye0VxTV811ovJw3TdvrWPWzWgu6
         LHKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vtff4Fyy/X+zK16oko5L4cb2bhj+IH/p2iuCVMyodUM=;
        b=rt1A3BO//2FttcCxPlCpwzBEZkVnm56pCVycG1Kh/+bGKY3ReO0nfJqYlmoKi6O8n/
         jhmxVTTdHTUcb1w9lEgHbYKBDyw0eA2Zw1HfdJAtuMfX3T+VRQPXBIFmyxaV+DUt3rmY
         kACFtkZ6wsSUZh5mCZpYZWDKIBRxrnOa+N9T6wdgWr/nLBkMCAFe8d7glhoBh66CBGWC
         1dXC6BiwyIPYCoEAc3bOplrRHRwyB0DGJDFKbmn9q1tbZTd+Lx2wXpl4A7wym1vvEp/4
         Zj0DplXERswlRlU32ntdnPPcRe4xelMQg+JL+FAtG1f6AaEC5VX1JNPrmrQKvEI6+eUY
         5dng==
X-Gm-Message-State: APjAAAV/MYlOW86UNA7QjWK+ousy+tfo3rkrDRj0TNugmjz6mPlHiC+K
        vD2YEQjE5gx22ju9TS1gUKCOMw==
X-Google-Smtp-Source: APXvYqw8Ym4xViVA4O0RwbU9bfd/7b4ZpnzI2WownGzt9kT6xKS2KJGTw8VxpdEC8wBYbd3uR4qRgQ==
X-Received: by 2002:a62:2d3:: with SMTP id 202mr1431194pfc.131.1565063204145;
        Mon, 05 Aug 2019 20:46:44 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id o12sm15037699pjr.22.2019.08.05.20.46.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 20:46:44 -0700 (PDT)
Date:   Mon, 5 Aug 2019 20:46:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v2 0/8][pull request] 40GbE Intel Wired LAN Driver
 Updates 2019-08-05
Message-ID: <20190805204620.2e27c95b@cakuba.netronome.com>
In-Reply-To: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
References: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  5 Aug 2019 11:54:51 -0700, Jeff Kirsher wrote:
> This series contains updates to i40e driver only.
> 
> Dmitrii adds missing statistic counters for VEB and VEB TC's.
> 
> Slawomir adds support for logging the "Disable Firmware LLDP" flag
> option and its current status.
> 
> Jake fixes an issue where VF's being notified of their link status
> before their queues are enabled which was causing issues.  So always
> report link status down when the VF queues are not enabled.  Also adds
> future proofing when statistics are added or removed by adding checks to
> ensure the data pointer for the strings lines up with the expected
> statistics count.
> 
> Czeslaw fixes the advertised mode reported in ethtool for FEC, where the
> "None BaseR RS" was always being displayed no matter what the mode it
> was in.  Also added logging information when the PF is entering or
> leaving "allmulti" (or promiscuous) mode.  Fixed up the logging logic
> for VF's when leaving multicast mode to not include unicast as well.

I can understand patch 2 may be useful for troubleshooting since FW
agent is involved. But I can't really say the same for patch 6 :S
If those entered allmutli/left allmutli messages were of value core
should print them instead..

But anyway, that's not a big deal, looks reasonable.
