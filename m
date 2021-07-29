Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08F53D9BE8
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbhG2Clm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhG2Cll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 22:41:41 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7201AC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 19:41:39 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id z6-20020a9d24860000b02904d14e47202cso4318631ota.4
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 19:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bD+cyH55KRnrC9r3OB1+weJujxHW2BLG2Pq/ouRDju8=;
        b=MlWvbf19X/34xs9Q72gi8KvDZsS+Dbhs+37on+jJ/QlfEUgz7LFn0iXfavwMG2CBKe
         /xk0Sx06rAoJOoDiSYTmobPsrS5MFLrPXVUEh6B9CsEhhsdSz10CPEM5Jq/urc/bO/Ij
         TC2qcoZmottZukRsYKzvjGq0ApZOgVYIcj/jspSvQdJ1X8CIj/gWX0FpKLbTq517d4HK
         BsywRX6aRVYLhmjHzJny/gx8osoVHVO2cqSGeno6uuicExt5seQOUItTI6COJOx2N5Np
         ynn50+NUD6OhUYses0BPik7SFNaiQL0bZ16v+7zaggRLdEHC5VYkHWPqHl1fmxiZjSnk
         Gk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bD+cyH55KRnrC9r3OB1+weJujxHW2BLG2Pq/ouRDju8=;
        b=mAG5lf9S7BYvgiolvqg/vLDGFqQx2BQF3pz5xLsWtqVZpnOhYTr7q9ae+nqD2yXLc1
         xNDZQPvuR1edzrM2n5guK2HVQU8sSQtKjfP4T/Vy2rSrqxHd0UGBJdWr7TVm+LoHkkDO
         sdkb2La3XrV6T+w9CpKdvbbiECQzEGOQD33HX/yZ8nIaAb/6kNS+NgkOpQq5J993IYNz
         TtKxAjy/9+t/4oKfVUw3VBOXpwPnjtfCH8f+1CynbZq4Qmyd5iGXztbvivQ+/KcZo/wS
         zssirAON1JoHxPNunxaMb9NKDIbsqPniegE0arA8r1D5+8EG1xDcW1WDeJlCb93fhnMn
         m47Q==
X-Gm-Message-State: AOAM531/3LWdBdewrQ0L/uWw9SPwfPP+1emYigLRwACXMHGbvA9vYg0r
        t1t1NX4rRUw73xZflWJ0p+0=
X-Google-Smtp-Source: ABdhPJyw/IGnB7oGXAwDR7nS91hywQy77dUW1fRH1RstiynLs5GRbb8tix/5vpq8h26nRaMsqFPn7g==
X-Received: by 2002:a9d:30d:: with SMTP id 13mr2034005otv.66.1627526498736;
        Wed, 28 Jul 2021 19:41:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id c8sm333589oto.17.2021.07.28.19.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 19:41:38 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 1/3] Add, show, link, remove IOAM
 namespaces and schemas
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20210724172108.26524-1-justin.iurman@uliege.be>
 <20210724172108.26524-2-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <54514656-7e71-6071-a5b2-d6aa8eed6275@gmail.com>
Date:   Wed, 28 Jul 2021 20:41:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210724172108.26524-2-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/21 11:21 AM, Justin Iurman wrote:
> +static void print_schema(struct rtattr *attrs[])
> +{
> +	__u8 data[IOAM6_MAX_SCHEMA_DATA_LEN + 1];
> +	int len;
> +
> +	print_uint(PRINT_ANY, "schema", "schema %u",
> +		   rta_getattr_u32(attrs[IOAM6_ATTR_SC_ID]));
> +
> +	if (attrs[IOAM6_ATTR_NS_ID])
> +		print_uint(PRINT_ANY, "namespace", " [namespace %u]",
> +			   rta_getattr_u16(attrs[IOAM6_ATTR_NS_ID]));
> +
> +	len = RTA_PAYLOAD(attrs[IOAM6_ATTR_SC_DATA]);
> +	memcpy(data, RTA_DATA(attrs[IOAM6_ATTR_SC_DATA]), len);
> +	data[len] = '\0';
> +
> +	print_string(PRINT_ANY, "data", ", data \"%s\"", (const char *)data);

The attribute descriptions shows this as binary data, not a string.

> +	print_null(PRINT_ANY, "", "\n", NULL);
> +}
> +
> +static int process_msg(struct nlmsghdr *n, void *arg)
> +{
> +	struct rtattr *attrs[IOAM6_ATTR_MAX + 1];
> +	struct genlmsghdr *ghdr;
> +	int len = n->nlmsg_len;
> +
> +	if (n->nlmsg_type != genl_family)
> +		return -1;
> +
> +	len -= NLMSG_LENGTH(GENL_HDRLEN);
> +	if (len < 0)
> +		return -1;
> +
> +	ghdr = NLMSG_DATA(n);
> +	parse_rtattr(attrs, IOAM6_ATTR_MAX, (void *)ghdr + GENL_HDRLEN, len);
> +
> +	open_json_object(NULL);
> +	switch (ghdr->cmd) {
> +	case IOAM6_CMD_DUMP_NAMESPACES:
> +		print_namespace(attrs);
> +		break;
> +	case IOAM6_CMD_DUMP_SCHEMAS:
> +		print_schema(attrs);
> +		break;
> +	}
> +	close_json_object();
> +
> +	return 0;
> +}
> +
> +static int ioam6_do_cmd(void)
> +{
> +	IOAM6_REQUEST(req, 1036, opts.cmd, NLM_F_REQUEST);
> +	int dump = 0;
> +
> +	if (genl_family < 0) {
> +		if (rtnl_open_byproto(&grth, 0, NETLINK_GENERIC) < 0) {
> +			fprintf(stderr, "Cannot open generic netlink socket\n");
> +			exit(1);
> +		}
> +		genl_family = genl_resolve_family(&grth, IOAM6_GENL_NAME);

The above 2 calls can be done with genl_init_handle.

> +		if (genl_family < 0)
> +			exit(1);
> +		req.n.nlmsg_type = genl_family;
> +	}
> +


> +int do_ioam6(int argc, char **argv)
> +{
> +	bool maybe_wide = false;
> +
> +	if (argc < 1 || matches(*argv, "help") == 0)
> +		usage();
> +
> +	memset(&opts, 0, sizeof(opts));
> +
> +	if (matches(*argv, "namespace") == 0) {

matches has been shown to be quite frail. Convenient for shorthand
typing commands, but frail in the big picture. We should stop using it -
especially for new commands.



