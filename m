Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFF57E33B
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 21:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388598AbfHATRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:17:42 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40051 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfHATRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 15:17:42 -0400
Received: by mail-qk1-f194.google.com with SMTP id s145so52935776qke.7;
        Thu, 01 Aug 2019 12:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=sRRiRudfVesVn/6GMaai5lXBbVTh+LZyVmU+cspSzXM=;
        b=oP/qcp7e7SDYkq4SklR2U463DOEjUG4XH1YJwo0VEXBwicGboi5pGMn9abgg1uE6Xj
         fRhU7NN5gxmDrnvq2yP/Cbd18TjvIpe+oVr0tv0H3Z/bRc04MMMeIGxtdBimifVARFAZ
         16UNH5EY/Ds7R3HDg4JY0C3nKuulhZ9fBhGkpfLNMn+krDlZQ5YhexVczp+M/AxYX457
         Z+nWS9w5zyF2p3XiT6fipxcUJixAslkf0NJ5+aZ77DkOGS2/zawWMKVM3E6zIplMZe3O
         FqSqbOuiacf4qjJngTBhzjbXTm4PxSioxliQWYbDhyJsosAp2WaV9vvKcon/rOTdCY+l
         Aaqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=sRRiRudfVesVn/6GMaai5lXBbVTh+LZyVmU+cspSzXM=;
        b=LHIZ68GeXKKLHT/XG/UU6Oy0ihng908E2LuEQzYsc7KlEPVUXqdTxl/hhnQgZGW/89
         ktWtpU0SEDdgKeBVCjiCa6Y343qmmulTKLVy+Po6ZG7yZ+UayvBCANPE9QfpD1BdZKdp
         SSn8KbRlRRIOx7A1zAioKx2CY/qikowo23eb+G8dfcgFXngwJfqrq+Fs8hrmNWFmtZ7r
         QoTR/uvtmMDUVxUuGldJyGJAlKCFQr1vQRwgUPMCUvlVK7pGjqThi1T9K06euQ8wRvrz
         8/kuqtdF7kIpRkfMCsujhPzfvITHVw4TRl7U0OpxKvcULEyFE268EeJjDJIH738izyim
         xIfQ==
X-Gm-Message-State: APjAAAVsttshSdrng75rsZzU2FyU8UYzRSulAUJ0tuySgvOdCR65LcJe
        WFUWL+ien40lDxWGaD7PNlM=
X-Google-Smtp-Source: APXvYqwbb+2/P206McEARDR/PpaP7VGFQSLFT8WPG1r9AaOcQVeVBRt8JCgiRpqNZSS57GaRn0zqwg==
X-Received: by 2002:a05:620a:1404:: with SMTP id d4mr87093639qkj.228.1564687060980;
        Thu, 01 Aug 2019 12:17:40 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w25sm29324472qto.87.2019.08.01.12.17.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 12:17:40 -0700 (PDT)
Date:   Thu, 1 Aug 2019 15:17:39 -0400
Message-ID: <20190801151739.GB32290@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        allan.nielsen@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
In-Reply-To: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Thu, 25 Jul 2019 13:44:04 +0200, Horatiu Vultur <horatiu.vultur@microchip.com> wrote:
> There is no way to configure the bridge, to receive only specific link
> layer multicast addresses. From the description of the command 'bridge
> fdb append' is supposed to do that, but there was no way to notify the
> network driver that the bridge joined a group, because LLADDR was added
> to the unicast netdev_hw_addr_list.
> 
> Therefore update fdb_add_entry to check if the NLM_F_APPEND flag is set
> and if the source is NULL, which represent the bridge itself. Then add
> address to multicast netdev_hw_addr_list for each bridge interfaces.
> And then the .ndo_set_rx_mode function on the driver is called. To notify
> the driver that the list of multicast mac addresses changed.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_fdb.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index b1d3248..d93746d 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -175,6 +175,29 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
>  	}
>  }
>  
> +static void fdb_add_hw_maddr(struct net_bridge *br, const unsigned char *addr)
> +{
> +	int err;
> +	struct net_bridge_port *p;
> +
> +	ASSERT_RTNL();
> +
> +	list_for_each_entry(p, &br->port_list, list) {
> +		if (!br_promisc_port(p)) {
> +			err = dev_mc_add(p->dev, addr);
> +			if (err)
> +				goto undo;
> +		}
> +	}
> +
> +	return;
> +undo:
> +	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
> +		if (!br_promisc_port(p))
> +			dev_mc_del(p->dev, addr);
> +	}
> +}
> +
>  /* When a static FDB entry is deleted, the HW address from that entry is
>   * also removed from the bridge private HW address list and updates all
>   * the ports with needed information.
> @@ -192,13 +215,27 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
>  	}
>  }
>  
> +static void fdb_del_hw_maddr(struct net_bridge *br, const unsigned char *addr)
> +{
> +	struct net_bridge_port *p;
> +
> +	ASSERT_RTNL();
> +
> +	list_for_each_entry(p, &br->port_list, list) {
> +		if (!br_promisc_port(p))
> +			dev_mc_del(p->dev, addr);
> +	}
> +}
> +
>  static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>  		       bool swdev_notify)
>  {
>  	trace_fdb_delete(br, f);
>  
> -	if (f->is_static)
> +	if (f->is_static) {
>  		fdb_del_hw_addr(br, f->key.addr.addr);
> +		fdb_del_hw_maddr(br, f->key.addr.addr);
> +	}
>  
>  	hlist_del_init_rcu(&f->fdb_node);
>  	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
> @@ -843,13 +880,19 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>  			fdb->is_local = 1;
>  			if (!fdb->is_static) {
>  				fdb->is_static = 1;
> -				fdb_add_hw_addr(br, addr);
> +				if (flags & NLM_F_APPEND && !source)
> +					fdb_add_hw_maddr(br, addr);
> +				else
> +					fdb_add_hw_addr(br, addr);
>  			}
>  		} else if (state & NUD_NOARP) {
>  			fdb->is_local = 0;
>  			if (!fdb->is_static) {
>  				fdb->is_static = 1;
> -				fdb_add_hw_addr(br, addr);
> +				if (flags & NLM_F_APPEND && !source)
> +					fdb_add_hw_maddr(br, addr);
> +				else
> +					fdb_add_hw_addr(br, addr);
>  			}
>  		} else {
>  			fdb->is_local = 0;
> -- 
> 2.7.4
> 

I'm a bit late in the conversation. Isn't this what you want?

    ip address add <multicast IPv4 address> dev br0 autojoin


Thanks,
Vivien
