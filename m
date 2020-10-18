Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFA0291839
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgJRQG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 12:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgJRQG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 12:06:27 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89054C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 09:06:27 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id f37so8111972otf.12
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 09:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N4W8bXJogVfRGQbDEWWpvHuipAkY5Dj2uAmkSQceJl4=;
        b=PHTgQmh88ZngaM1xL4ZK9Im+gCw++C2RmwtirIysoUsYIgyneozPeaouwpns8A5Os2
         qGRfroQnKEk0iaNQZARG4WVY/rWJ/eTqFyXWelWyxuceaOmIvFLgGj6SriZeT7GT5/kG
         7FcSS/0p8/aQ1uJcN+YCNLSZ6p0J9kdFVJ+JVIWfe2YlAoi7TgYDz+jnGld3RN8hR5qg
         1vB7h3HuEF6gYOr24i7b3V/uGXe4p5pl8SlyjdQKCzm+oowCFMP/KtzoMUP0H397ItZO
         ve2TRkRVIlvgXoSc1p+R0/nZZVhIjuEa4xR9kA8Cyst12cLHy84j6kcZ/bQor40cpWkp
         ifLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N4W8bXJogVfRGQbDEWWpvHuipAkY5Dj2uAmkSQceJl4=;
        b=XADP9D2uLq4LKEh75LwJrRHrpbRckOt4wBTNZVpjnv6dhM9/FE/iPt6TNKnhhtyX+x
         trJIc0aH+pEzQ/YUHSMConMyT4WmU4U+4AJsm94U9tycYznj6A4zd63lm1RjUhJLv/46
         1323IGVMOvTzY75clLVMnp3e0lw10/ctDFqm38hPG9mhSVstKVlVWbUGZqABDrrzi2/Z
         abKwxdBpCijoD59CImJgrs7pTmYG8bKTuqh6nznPIUhAq9OL8svv2rhu5jIT5vJ0jtbJ
         KZPVtBlKG9agTj74jZYQpVKTSCzgOXeEvAaFXDxNHSZ4D2gCsxFIYimr7FdPkK0sj7Nr
         +xjQ==
X-Gm-Message-State: AOAM532GlGAZAWYUUKDsoJmsRgm1I5pCn3hVCQqOcv/++tJQUFRNZE3y
        0z9DzBFQOm8e1pkrw9HBYg==
X-Google-Smtp-Source: ABdhPJyQVA4px0/TM35nNrBJ7AwRVkgATyYz1eIQiXCe8xIFzSjSPZ++c1ybeoxIqDVkfXIB8JWquA==
X-Received: by 2002:a05:6830:138f:: with SMTP id d15mr8851453otq.367.1603037186936;
        Sun, 18 Oct 2020 09:06:26 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id u125sm2841702oif.21.2020.10.18.09.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 09:06:26 -0700 (PDT)
Date:   Sun, 18 Oct 2020 12:06:24 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, sashal@kernel.org,
        mmanning@vyatta.att-mail.com
Subject: Re: Why revert commit 2271c95 ("vrf: mark skb for multicast or
 link-local as enslaved to VRF")?
Message-ID: <20201018160624.GB11729@ICIPI.localdomain>
References: <20201018132436.GA11729@ICIPI.localdomain>
 <75fda8c7-adf3-06a4-298f-b75ac6e6969b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75fda8c7-adf3-06a4-298f-b75ac6e6969b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 09:27:16AM -0600, David Ahern wrote:
> On 10/18/20 7:24 AM, Stephen Suryaputra wrote:
> > Greetings,
> > 
> > We noticed that the commit was reverted after upgrading to v4.14.200.
> > Any reason why it is reverted? We rely on it.
> > 
> 
> $ git show 2271c95
> fatal: ambiguous argument '2271c95': unknown revision or path not in the
> working tree.
> Use '--' to separate paths from revisions, like this:
> 'git <command> [<revision>...] -- [<file>...]'

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
$ git checkout v4.14.200
$ git --no-pager show 2271c95

commit 2271c9500434af2a26b2c9eadeb3c0b075409fb5
Author: Mike Manning <mmanning@vyatta.att-mail.com>
Date:   Wed Nov 7 15:36:07 2018 +0000

    vrf: mark skb for multicast or link-local as enslaved to VRF
    
    [ Upstream commit 6f12fa775530195a501fb090d092c637f32d0cc5 ]
    
    The skb for packets that are multicast or to a link-local address are
    not marked as being enslaved to a VRF, if they are received on a socket
    bound to the VRF. This is needed for ND and it is preferable for the
    kernel not to have to deal with the additional use-cases if ll or mcast
    packets are handled as enslaved. However, this does not allow service
    instances listening on unbound and bound to VRF sockets to distinguish
    the VRF used, if packets are sent as multicast or to a link-local
    address. The fix is for the VRF driver to also mark these skb as being
    enslaved to the VRF.
    
    Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
    Reviewed-by: David Ahern <dsahern@gmail.com>
    Tested-by: David Ahern <dsahern@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 03e4fcdfeab7..e0cea5c05f0e 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -996,24 +996,23 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 				   struct sk_buff *skb)
 {
 	int orig_iif = skb->skb_iif;
-	bool need_strict;
+	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
+	bool is_ndisc = ipv6_ndisc_frame(skb);
 
-	/* loopback traffic; do not push through packet taps again.
-	 * Reset pkt_type for upper layers to process skb
+	/* loopback, multicast & non-ND link-local traffic; do not push through
+	 * packet taps again. Reset pkt_type for upper layers to process skb
 	 */
-	if (skb->pkt_type == PACKET_LOOPBACK) {
+	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
-		skb->pkt_type = PACKET_HOST;
+		if (skb->pkt_type == PACKET_LOOPBACK)
+			skb->pkt_type = PACKET_HOST;
 		goto out;
 	}
 
-	/* if packet is NDISC or addressed to multicast or link-local
-	 * then keep the ingress interface
-	 */
-	need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
-	if (!ipv6_ndisc_frame(skb) && !need_strict) {
+	/* if packet is NDISC then keep the ingress interface */
+	if (!is_ndisc) {
 		vrf_rx_stats(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;

$ git --no-pager show afed1a4

commit afed1a4dbb76c81900f10fd77397fb91ad442702
Author: Sasha Levin <sashal@kernel.org>
Date:   Mon Mar 23 16:21:31 2020 -0400

    Revert "vrf: mark skb for multicast or link-local as enslaved to VRF"
    
    This reverts commit 2271c9500434af2a26b2c9eadeb3c0b075409fb5.
    
    This patch shouldn't have been backported to 4.14.
    
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index e0cea5c05f0e..03e4fcdfeab7 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -996,23 +996,24 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 				   struct sk_buff *skb)
 {
 	int orig_iif = skb->skb_iif;
-	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
-	bool is_ndisc = ipv6_ndisc_frame(skb);
+	bool need_strict;
 
-	/* loopback, multicast & non-ND link-local traffic; do not push through
-	 * packet taps again. Reset pkt_type for upper layers to process skb
+	/* loopback traffic; do not push through packet taps again.
+	 * Reset pkt_type for upper layers to process skb
 	 */
-	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
+	if (skb->pkt_type == PACKET_LOOPBACK) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
-		if (skb->pkt_type == PACKET_LOOPBACK)
-			skb->pkt_type = PACKET_HOST;
+		skb->pkt_type = PACKET_HOST;
 		goto out;
 	}
 
-	/* if packet is NDISC then keep the ingress interface */
-	if (!is_ndisc) {
+	/* if packet is NDISC or addressed to multicast or link-local
+	 * then keep the ingress interface
+	 */
+	need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
+	if (!ipv6_ndisc_frame(skb) && !need_strict) {
 		vrf_rx_stats(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
