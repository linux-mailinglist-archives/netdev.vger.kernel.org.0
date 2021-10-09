Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5346427C0C
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 18:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhJIQhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 12:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhJIQhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 12:37:11 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D93C061570;
        Sat,  9 Oct 2021 09:35:14 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z20so48268066edc.13;
        Sat, 09 Oct 2021 09:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0C0jtXlUemrvTfFGLd5U564fJDXW6hIV9Kk9lIcp7HU=;
        b=F9NnHm/tkU5hikHGUgMKvfy5ZJ3U1LG3KVWSEpRRXTOhcJij47WDhauKGhBzRbfU3a
         /jxchh0Nf9BW8OhIxH6Lx6eurXy1/XKCTC8z4jhbrQe/a/LAlJ4aR0TAK9yYjr9Waubu
         u4v4QAyykolJ6qg2IFTPVN8EOY2Hgkd2NTxjVO7KsYKNdWjK0aP+5l6XSItJUq8oS8MF
         dme+njRdhln2c6Zx9PuURu4kU7RKYdcGfq6mgcubSanQvCWXfqdPh7DQCz8dGUL6Yips
         gaHyFYnwzlCxe9gF5/jHA+YsqvNx8xX/fdaJZMgnjI99HZfw6LcU0HvIUyfbwKTSnqBZ
         J77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0C0jtXlUemrvTfFGLd5U564fJDXW6hIV9Kk9lIcp7HU=;
        b=BcGz2c1pwHfbouhwgxXwFbZYlhNxFbQdf6m8NeC/tuVIMozSrVFHBCT8SC2Trzt0IX
         iuR96woczFG2Ckk1TBCbDzsymHHOa/kVMQ3TWVtvVzziRQG5NzSzxywHXvjA9Y0lNGsR
         4ZXWXc9D/P20cMUAQOn9+Zmh0SlsgHdNXy/nTlk35nFROl9yxwUeAjjuRox2Eo4jOp2y
         DY5sm30xRnMVvV4Vf6+ZK67WiCNjdOQIhCOnlLbnOGa5QIAOCX8RH2Usgd95hwZFIYZl
         r5pVyipgWqLECSeZ1OwAZcqe5vIwBo5H9Qad3UsftrF74tyV4L0jPyJoj43DtDWa69be
         6Q7w==
X-Gm-Message-State: AOAM531bsHog66iqPgKWdmJu4v78mw65GofbSKonivVywLHZIzJDeBWw
        KwkT0an4ZUtrkXXLsv8Osew=
X-Google-Smtp-Source: ABdhPJxOTj6WAkC6No7bUmEb/f6io4w8NtTML2Jm/87vAOC9hLyKt2rpvHTQeCXAaifIrSoy/Utjdw==
X-Received: by 2002:a17:906:b6d0:: with SMTP id ec16mr13223552ejb.229.1633797313011;
        Sat, 09 Oct 2021 09:35:13 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id 10sm1148703ejo.111.2021.10.09.09.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 09:35:12 -0700 (PDT)
Date:   Sat, 9 Oct 2021 19:35:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: procfs: add seq_puts() statement for
 dev_mcast
Message-ID: <20211009163511.vayjvtn3rrteglsu@skbuf>
References: <20210816085757.28166-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816085757.28166-1-yajun.deng@linux.dev>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 04:57:57PM +0800, Yajun Deng wrote:
> Add seq_puts() statement for dev_mcast, make it more readable.
> As also, keep vertical alignment for {dev, ptype, dev_mcast} that
> under /proc/net.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---

FYI, this program got broken by this commit (reverting it restores
functionality):

root@debian:~# ifstat
ifstat: /proc/net/dev: unsupported format.

Confusingly enough, the "ifstat" provided by Debian is not from iproute2:
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/misc/ifstat.c
but rather a similarly named program:
https://packages.debian.org/source/bullseye/ifstat
https://github.com/matttbe/ifstat

I haven't studied how this program parses /proc/net/dev, but here's how
the kernel's output changed:

Doesn't work:

root@debian:~# cat /proc/net/dev
Interface|                            Receive                                       |                                 Transmit
         |            bytes      packets errs   drop fifo frame compressed multicast|            bytes      packets errs   drop fifo colls carrier compressed
       lo:            97400         1204    0      0    0     0          0         0            97400         1204    0      0    0     0       0          0
    bond0:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
     sit0:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
     eno2:          5002206         6651    0      0    0     0          0         0        105518642      1465023    0      0    0     0       0          0
     swp0:           134531         2448    0      0    0     0          0         0         99599598      1464381    0      0    0     0       0          0
     swp1:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
     swp2:          4867675         4203    0      0    0     0          0         0            58134          631    0      0    0     0       0          0
    sw0p0:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
    sw0p1:           124739         2448    0   1422    0     0          0         0         93741184      1464369    0      0    0     0       0          0
    sw0p2:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
    sw2p0:          4850863         4203    0      0    0     0          0         0            54722          619    0      0    0     0       0          0
    sw2p1:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
    sw2p2:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
    sw2p3:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
      br0:            10508          212    0    212    0     0          0       212         61369558       958857    0      0    0     0       0          0

Works:

root@debian:~# cat /proc/net/dev
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:   13160     164    0    0    0     0          0         0    13160     164    0    0    0     0       0          0
 bond0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
  sit0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
  eno2:   30824     268    0    0    0     0          0         0     3332      37    0    0    0     0       0          0
  swp0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
  swp1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
  swp2:   30824     268    0    0    0     0          0         0     2428      27    0    0    0     0       0          0
 sw0p0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw0p1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw0p2:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw2p0:   29752     268    0    0    0     0          0         0     1564      17    0    0    0     0       0          0
 sw2p1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw2p2:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw2p3:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0

>  net/core/net-procfs.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index d8b9dbabd4a4..eab5fc88a002 100644
> --- a/net/core/net-procfs.c
> +++ b/net/core/net-procfs.c
> @@ -77,8 +77,8 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
>  	struct rtnl_link_stats64 temp;
>  	const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
>  
> -	seq_printf(seq, "%6s: %7llu %7llu %4llu %4llu %4llu %5llu %10llu %9llu "
> -		   "%8llu %7llu %4llu %4llu %4llu %5llu %7llu %10llu\n",
> +	seq_printf(seq, "%9s: %16llu %12llu %4llu %6llu %4llu %5llu %10llu %9llu "
> +		   "%16llu %12llu %4llu %6llu %4llu %5llu %7llu %10llu\n",
>  		   dev->name, stats->rx_bytes, stats->rx_packets,
>  		   stats->rx_errors,
>  		   stats->rx_dropped + stats->rx_missed_errors,
> @@ -103,11 +103,11 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
>  static int dev_seq_show(struct seq_file *seq, void *v)
>  {
>  	if (v == SEQ_START_TOKEN)
> -		seq_puts(seq, "Inter-|   Receive                            "
> -			      "                    |  Transmit\n"
> -			      " face |bytes    packets errs drop fifo frame "
> -			      "compressed multicast|bytes    packets errs "
> -			      "drop fifo colls carrier compressed\n");
> +		seq_puts(seq, "Interface|                            Receive                   "
> +			      "                    |                                 Transmit\n"
> +			      "         |            bytes      packets errs   drop fifo frame "
> +			      "compressed multicast|            bytes      packets errs "
> +			      "  drop fifo colls carrier compressed\n");
>  	else
>  		dev_seq_printf_stats(seq, v);
>  	return 0;
> @@ -259,14 +259,14 @@ static int ptype_seq_show(struct seq_file *seq, void *v)
>  	struct packet_type *pt = v;
>  
>  	if (v == SEQ_START_TOKEN)
> -		seq_puts(seq, "Type Device      Function\n");
> +		seq_puts(seq, "Type      Device      Function\n");
>  	else if (pt->dev == NULL || dev_net(pt->dev) == seq_file_net(seq)) {
>  		if (pt->type == htons(ETH_P_ALL))
>  			seq_puts(seq, "ALL ");
>  		else
>  			seq_printf(seq, "%04x", ntohs(pt->type));
>  
> -		seq_printf(seq, " %-8s %ps\n",
> +		seq_printf(seq, "      %-9s   %ps\n",
>  			   pt->dev ? pt->dev->name : "", pt->func);
>  	}
>  
> @@ -327,12 +327,14 @@ static int dev_mc_seq_show(struct seq_file *seq, void *v)
>  	struct netdev_hw_addr *ha;
>  	struct net_device *dev = v;
>  
> -	if (v == SEQ_START_TOKEN)
> +	if (v == SEQ_START_TOKEN) {
> +		seq_puts(seq, "Ifindex Interface Refcount Global_use Address\n");
>  		return 0;
> +	}
>  
>  	netif_addr_lock_bh(dev);
>  	netdev_for_each_mc_addr(ha, dev) {
> -		seq_printf(seq, "%-4d %-15s %-5d %-5d %*phN\n",
> +		seq_printf(seq, "%-7d %-9s %-8d %-10d %*phN\n",
>  			   dev->ifindex, dev->name,
>  			   ha->refcount, ha->global_use,
>  			   (int)dev->addr_len, ha->addr);
> -- 
> 2.32.0
> 
