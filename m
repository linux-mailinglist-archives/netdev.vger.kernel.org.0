Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616FD620B9
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbfGHOoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:44:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38247 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfGHOoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:44:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so7293837wrr.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 07:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vKTWfrvoH1MBcjQFx+vnbC/kqx9pKDBMPUsbOwtRCeQ=;
        b=wf7cvIIZ4Fdui9npLIEtaCMlVYxflVKSswBIoc7UJxREvayZw1QqfPxs6O7F9w0gXk
         oNoTTlSFqxgtLlo0b9+vzzjV4V60Fm++kdJATT2DB7ywlmw9kmqLJEQwRtOfUVXJgkaD
         eHXbl7K0/Dv9hUaGrsde1t9Nu6BDDvZHtENN7Owdzb2NziPZFj3qPHO9ef+nlX+0I0wK
         8ur9jbBixF9bKxyV3k540XOBx/WiVKbexthktmhO/nsgIgTvzGbl3aLP7mBZYQxjKrTF
         kmY+6aup5qKZGOb2uWZ5IDTxvX2WwMN2ryBTvdwU8m1ncRkW23+1gVeYqBFhVyVaePqF
         TIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vKTWfrvoH1MBcjQFx+vnbC/kqx9pKDBMPUsbOwtRCeQ=;
        b=nZJ3DKVCMoap/PdqfLpf7FKEmyvdBii2NLkShG4+y0Fq3ZJjv0pzQvYxJ2260C7OYs
         dfxjVPR3Mezh6HJN1M9Jy9sMxeDANCx0GRqV4sGxNOrDFInmNy7HYkAnhHVoOzzbvLpo
         hXKERMewtwY4IQ5fYntELKkw2gPI9rXLoebb6fYIKihX5/l29IOMCAEYdRH6IORgtC3y
         WVzSiMdOTLVHeVvGDc3qxd3BpEu0BP1dYs65kYcqMpdV2xhLmBCj4lmpiJ4SF7takTw2
         6ApYEvbUamPoBnjLvMAs3h2yNrImS3FdpquMkJmSGLDjIwGn0hz+CPjahd2BK+YfwtmI
         E2/g==
X-Gm-Message-State: APjAAAWz8YjSCTHZIYHKOuhVzv2thw+lqH+mepHvXZhtwP34xzlNJu50
        nxqzgKD02m+lQBNPbf+c0LVTMQ4R6v8=
X-Google-Smtp-Source: APXvYqzXpQeA1OC0QzOj2Sv0or95DYBXBL+aVlvGlmVaO6LblswcrXmKuuB24TO8E+BaTqoMKASjrA==
X-Received: by 2002:adf:ec0f:: with SMTP id x15mr19561222wrn.165.1562597042840;
        Mon, 08 Jul 2019 07:44:02 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id q16sm30725996wra.36.2019.07.08.07.44.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 07:44:02 -0700 (PDT)
Date:   Mon, 8 Jul 2019 16:44:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 1/5] devlink: Refactor physical port
 attributes
Message-ID: <20190708144401.GL2201@nanopsycho>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190708041549.56601-1-parav@mellanox.com>
 <20190708041549.56601-2-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708041549.56601-2-parav@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 08, 2019 at 06:15:45AM CEST, parav@mellanox.com wrote:
>To support additional devlink port flavours and to support few common
>and few different port attributes, move physical port attributes to a
>different structure.
>
>Signed-off-by: Parav Pandit <parav@mellanox.com>
>---
>Changelog:
>v4->v5:
> - Addressed comments from Jiri.
> - Moved check for physical port flavours check to separate patch.
>v3->v4:
> - Addressed comments from Jiri.
> - Renamed phys_port to physical to be consistent with pci_pf.
> - Removed port_number from __devlink_port_attrs_set and moved
>   assigment to caller function.
> - Used capital letter while moving old comment to new structure.
> - Removed helper function is_devlink_phy_port_num_supported().
>v2->v3:
> - Address comments from Jakub.
> - Made port_number and split_port_number applicable only to
>   physical port flavours by having in union.
>v1->v2:
> - Limited port_num attribute to physical ports
> - Updated PCI PF attribute set API to not have port_number
>---
> include/net/devlink.h | 13 ++++++++--
> net/core/devlink.c    | 59 ++++++++++++++++++++++++++++---------------
> 2 files changed, 50 insertions(+), 22 deletions(-)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 6625ea068d5e..c79a1370867a 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -38,14 +38,23 @@ struct devlink {
> 	char priv[0] __aligned(NETDEV_ALIGN);
> };
> 
>+struct devlink_port_phys_attrs {
>+	u32 port_number; /* Same value as "split group".
>+			  * A physical port which is visible to the user
>+			  * for a given port flavour.
>+			  */
>+	u32 split_subport_number;
>+};
>+
> struct devlink_port_attrs {
> 	u8 set:1,
> 	   split:1,
> 	   switch_port:1;
> 	enum devlink_port_flavour flavour;
>-	u32 port_number; /* same value as "split group" */
>-	u32 split_subport_number;
> 	struct netdev_phys_item_id switch_id;
>+	union {
>+		struct devlink_port_phys_attrs physical;

You can shorten this to just "phys". Would be better.
With that
Acked-by: Jiri Pirko <jiri@mellanox.com>
