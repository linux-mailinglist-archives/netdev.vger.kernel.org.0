Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2131D86F22
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405170AbfHIBKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:10:43 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35438 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHIBKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:10:42 -0400
Received: from penelope.horms.nl (unknown [66.60.152.14])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 7283F25AEA9;
        Fri,  9 Aug 2019 11:10:40 +1000 (AEST)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 420DBE21A9A; Fri,  9 Aug 2019 03:10:39 +0200 (CEST)
Date:   Thu, 8 Aug 2019 18:10:39 -0700
From:   Simon Horman <horms@verge.net.au>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org
Subject: Re: [PATCH net-next] net: delete "register" keyword
Message-ID: <20190809011039.oggtodms4gc6gzpa@verge.net.au>
References: <20190805203441.GA24674@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805203441.GA24674@avx2>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 11:34:41PM +0300, Alexey Dobriyan wrote:
> Delete long obsoleted "register" keyword.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  drivers/net/ethernet/apple/bmac.c |    4 ++--
>  drivers/net/slip/slhc.c           |   30 +++++++++++++++---------------
>  net/netfilter/ipvs/ip_vs_ctl.c    |    4 ++--
>  net/netfilter/ipvs/ip_vs_lblcr.c  |    4 ++--
>  4 files changed, 21 insertions(+), 21 deletions(-)

IPVS portion:

Reviewed-by: Simon Horman <horms@verge.net.au>

> 
> --- a/drivers/net/ethernet/apple/bmac.c
> +++ b/drivers/net/ethernet/apple/bmac.c
> @@ -815,8 +815,8 @@ static int reverse6[64] = {
>  static unsigned int
>  crc416(unsigned int curval, unsigned short nxtval)
>  {
> -	register unsigned int counter, cur = curval, next = nxtval;
> -	register int high_crc_set, low_data_set;
> +	unsigned int counter, cur = curval, next = nxtval;
> +	int high_crc_set, low_data_set;
>  
>  	/* Swap bytes */
>  	next = ((next & 0x00FF) << 8) | (next >> 8);
> --- a/drivers/net/slip/slhc.c
> +++ b/drivers/net/slip/slhc.c
> @@ -91,8 +91,8 @@ static unsigned short pull16(unsigned char **cpp);
>  struct slcompress *
>  slhc_init(int rslots, int tslots)
>  {
> -	register short i;
> -	register struct cstate *ts;
> +	short i;
> +	struct cstate *ts;
>  	struct slcompress *comp;
>  
>  	if (rslots < 0 || rslots > 255 || tslots < 0 || tslots > 255)
> @@ -206,7 +206,7 @@ pull16(unsigned char **cpp)
>  static long
>  decode(unsigned char **cpp)
>  {
> -	register int x;
> +	int x;
>  
>  	x = *(*cpp)++;
>  	if(x == 0){
> @@ -227,14 +227,14 @@ int
>  slhc_compress(struct slcompress *comp, unsigned char *icp, int isize,
>  	unsigned char *ocp, unsigned char **cpp, int compress_cid)
>  {
> -	register struct cstate *ocs = &(comp->tstate[comp->xmit_oldest]);
> -	register struct cstate *lcs = ocs;
> -	register struct cstate *cs = lcs->next;
> -	register unsigned long deltaS, deltaA;
> -	register short changes = 0;
> +	struct cstate *ocs = &(comp->tstate[comp->xmit_oldest]);
> +	struct cstate *lcs = ocs;
> +	struct cstate *cs = lcs->next;
> +	unsigned long deltaS, deltaA;
> +	short changes = 0;
>  	int hlen;
>  	unsigned char new_seq[16];
> -	register unsigned char *cp = new_seq;
> +	unsigned char *cp = new_seq;
>  	struct iphdr *ip;
>  	struct tcphdr *th, *oth;
>  	__sum16 csum;
> @@ -486,11 +486,11 @@ slhc_compress(struct slcompress *comp, unsigned char *icp, int isize,
>  int
>  slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
>  {
> -	register int changes;
> +	int changes;
>  	long x;
> -	register struct tcphdr *thp;
> -	register struct iphdr *ip;
> -	register struct cstate *cs;
> +	struct tcphdr *thp;
> +	struct iphdr *ip;
> +	struct cstate *cs;
>  	int len, hdrlen;
>  	unsigned char *cp = icp;
>  
> @@ -543,7 +543,7 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
>  	switch(changes & SPECIALS_MASK){
>  	case SPECIAL_I:		/* Echoed terminal traffic */
>  		{
> -		register short i;
> +		short i;
>  		i = ntohs(ip->tot_len) - hdrlen;
>  		thp->ack_seq = htonl( ntohl(thp->ack_seq) + i);
>  		thp->seq = htonl( ntohl(thp->seq) + i);
> @@ -637,7 +637,7 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
>  int
>  slhc_remember(struct slcompress *comp, unsigned char *icp, int isize)
>  {
> -	register struct cstate *cs;
> +	struct cstate *cs;
>  	unsigned ihl;
>  
>  	unsigned char index;
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -262,7 +262,7 @@ static inline unsigned int
>  ip_vs_svc_hashkey(struct netns_ipvs *ipvs, int af, unsigned int proto,
>  		  const union nf_inet_addr *addr, __be16 port)
>  {
> -	register unsigned int porth = ntohs(port);
> +	unsigned int porth = ntohs(port);
>  	__be32 addr_fold = addr->ip;
>  	__u32 ahash;
>  
> @@ -493,7 +493,7 @@ static inline unsigned int ip_vs_rs_hashkey(int af,
>  					    const union nf_inet_addr *addr,
>  					    __be16 port)
>  {
> -	register unsigned int porth = ntohs(port);
> +	unsigned int porth = ntohs(port);
>  	__be32 addr_fold = addr->ip;
>  
>  #ifdef CONFIG_IP_VS_IPV6
> --- a/net/netfilter/ipvs/ip_vs_lblcr.c
> +++ b/net/netfilter/ipvs/ip_vs_lblcr.c
> @@ -160,7 +160,7 @@ static void ip_vs_dest_set_eraseall(struct ip_vs_dest_set *set)
>  /* get weighted least-connection node in the destination set */
>  static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
>  {
> -	register struct ip_vs_dest_set_elem *e;
> +	struct ip_vs_dest_set_elem *e;
>  	struct ip_vs_dest *dest, *least;
>  	int loh, doh;
>  
> @@ -209,7 +209,7 @@ static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
>  /* get weighted most-connection node in the destination set */
>  static inline struct ip_vs_dest *ip_vs_dest_set_max(struct ip_vs_dest_set *set)
>  {
> -	register struct ip_vs_dest_set_elem *e;
> +	struct ip_vs_dest_set_elem *e;
>  	struct ip_vs_dest *dest, *most;
>  	int moh, doh;
>  
> 
