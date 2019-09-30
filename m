Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44C5C2551
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732324AbfI3Qls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:41:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38771 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731459AbfI3Qlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:41:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id h195so5925247pfe.5
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 09:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I+RyNx9+357TsMn7H/7V+z/itG4FH7yZB3lve0DaABA=;
        b=XMH3zqPrKgQ+ulROS1ZjI3t4W1Ko61I8BQiGoE0kzcdhRGUCMl+EApNu+9+fMx86/N
         TkpVmAr8q5Q6krryrCx69jXJbjxhvvfH+9QAXsaKhW5z5Xoup3/y1QgU0JUN3yylfP+W
         Q8NynnE3bUY9hmtE6lRXp8JmkHx58NTO9nDp85ennJOQSd4pJFPKTaisYaBzulzwjwvM
         3b0AjuRwblQpaW7UM8HoEih3gB2x+iGOVzylyXERSjSI4pxLtn1fPwj88EZGwQCmR7WV
         dtK1pF4UiZDS4S5I/cULfntxvKGkBIBRQADlxEjNsUBddjDOFkb6P+ASLmKp4Lh2v+0x
         2Oag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I+RyNx9+357TsMn7H/7V+z/itG4FH7yZB3lve0DaABA=;
        b=pqKwvKNI5t2hrgm4oRMTmv+iqEqCNA3zfNKFdGh7NYzgpPNo97qvkqBan9CqAa4Jm8
         mftMleNV7bIY58M8aQM9BMUtrKSq1/rpcNNLZKqtOTfAJUh96Xh9u95CDBo+s9TvxpRb
         nN17v3T0zT7fel/zFUXbv85ApAJa7cOuFgvfcc5BFO8vNk444wRA8Uu0fdHd/F2AH14a
         eyprw7zsuLQXWSG/w1W4TgUg9w3lV8hl6/GdXnHipsUbBWR+h9wTgkiElooVaukmy3Vq
         oWi4MKn9chWNCxCLkbcranyg6s9lgdj80ouOAuY9ahRviRI6OSTo+e/7IaF+0ULITfqh
         TAFQ==
X-Gm-Message-State: APjAAAWTpBXdc9zUEOAVKVt/Cej4xeq+lrqIadW5leLiN/ZmKQpIjDgJ
        eSLWvzwuGEnTFq4qg+ycYko=
X-Google-Smtp-Source: APXvYqx67RC46XmvxqutnicSihG2Rc014GrVCg09GPjtDq/q+b4EDp/i0ogVijOSIqBK2A4F63fJdw==
X-Received: by 2002:a63:4b5e:: with SMTP id k30mr25291305pgl.408.1569861706984;
        Mon, 30 Sep 2019 09:41:46 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:38f1:aff0:4629:100f])
        by smtp.googlemail.com with ESMTPSA id h68sm16891557pfb.149.2019.09.30.09.41.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 09:41:46 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v2 1/2] bridge: fdb get support
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        stephen@networkplumber.org
References: <1569702130-46433-1-git-send-email-roopa@cumulusnetworks.com>
 <1569702130-46433-2-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ae9fd91-ab7c-c614-06e8-e8264bcfe96d@gmail.com>
Date:   Mon, 30 Sep 2019 10:41:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1569702130-46433-2-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/19 2:22 PM, Roopa Prabhu wrote:
> @@ -518,6 +520,113 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
>  	return 0;
>  }
>  
> +static int fdb_get(int argc, char **argv)
> +{
> +	struct {
> +		struct nlmsghdr	n;
> +		struct ndmsg		ndm;
> +		char			buf[1024];
> +	} req = {
> +		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ndmsg)),
> +		.n.nlmsg_flags = NLM_F_REQUEST,
> +		.n.nlmsg_type = RTM_GETNEIGH,
> +		.ndm.ndm_family = AF_BRIDGE,
> +	};
> +	struct nlmsghdr *answer;
> +	char *addr = NULL;
> +	char  *d = NULL, *br = NULL;
> +	char abuf[ETH_ALEN];
> +	unsigned long vni = ~0;
> +	int br_ifindex = 0;
> +	char *endptr;
> +	short vlan = -1;

iproute2 follows the net standards of reverse xmas tree for declarations.
