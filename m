Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8A761F761
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 16:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbiKGPQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 10:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbiKGPQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 10:16:49 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71541EAF9
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 07:16:44 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id z9so5985512ilu.10
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 07:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rxS8UhN1J+Ehig9XWWNbU/JxmCXj6PJxz5yUXVWMKYE=;
        b=UeqWg9jKUxdMz45Nrp5sELRpSA203R3PT5kAgzNvdQgWprBRBkZIIua2+Mn6voiWx3
         xJ1Ybp+EzfXm2cU75Z7OwK+n74v+ljv7zB8OlP91EKfOKyqdOXivS6yO4DW33l6cYJQE
         q6fONV/1l3DLK+etK6g/aEJVx9PXiGkY+LkzDLn3UGppK9ccT7/AqLu0KZi7Q0M6SRoB
         dGywMaS3UXHawZ4jzIdDJLHwCWok+JVsinIzuAtqMzOqOogK9bGblHXtDsOsvhOvRJSt
         7cMGFvrId1TYthcfmjl8h9+ha/VcGClGm9WoAmqxW5P6AW/qtISOIR1AlC3CiffqhF20
         qHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxS8UhN1J+Ehig9XWWNbU/JxmCXj6PJxz5yUXVWMKYE=;
        b=cxPatZc7PsY1VU6/T5ISd1rWYRXlLKnD5Hti3lpPHdgDJ32DnZMOOTeT85Cnx6qoVz
         rYy6hy1iLuDXKASt3mIyAC3U7+ynY5t+SuHMjx2oujxm63GcZUiCcDgBmbkmYkCt/XLH
         Vm91YcaUqJJyjOgCt2HxO9l4mhxwxGA6c95tp1/dKrivlx77s4Jtj03Wnye4EGIVL8wL
         jsXnd4IAxqfuXAjOn66BIT+xzY6frV1WJpcyvUaJ3JFqiUfDsBcmgF26wbaC4nK55blV
         ZAl9TtMImlKg9vWNDH+G0IZ3z4UNwcg3p9fjEzOWLGpAx8DtkJESCOxKXiZiu54RKmlb
         hWVg==
X-Gm-Message-State: ACrzQf0vzlhDWPKM3ExaRLKlRsErOzqCfqkj3kdi9mB/IZc9lT6M3qGL
        owmP4/0E4TVTaoJhSh/+Juk=
X-Google-Smtp-Source: AMsMyM4RoagWFCAgiInMA6GsiZuQN9oeSxXaltB5Bd/eeVOMM6FtjnZI8+W1Mlh/XLkTOmRjTeideQ==
X-Received: by 2002:a05:6e02:e43:b0:2f5:739f:7d4d with SMTP id l3-20020a056e020e4300b002f5739f7d4dmr29772787ilk.100.1667834204073;
        Mon, 07 Nov 2022 07:16:44 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:a10c:23e5:6dc3:8e07? ([2601:282:800:dc80:a10c:23e5:6dc3:8e07])
        by smtp.googlemail.com with ESMTPSA id o17-20020a92dad1000000b002fb78f6c166sm2932167ilq.10.2022.11.07.07.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 07:16:43 -0800 (PST)
Message-ID: <6903f920-dd02-9df0-628a-23d581c4aac6@gmail.com>
Date:   Mon, 7 Nov 2022 08:16:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [patch iproute2-next 1/3] devlink: query ifname for devlink port
 instead of map lookup
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, kuba@kernel.org, moshe@nvidia.com,
        aeedm@nvidia.com
References: <20221104102327.770260-1-jiri@resnulli.us>
 <20221104102327.770260-2-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20221104102327.770260-2-jiri@resnulli.us>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/22 4:23 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> ifname map is created once during init. However, ifnames can easily
> change during the devlink process runtime (e. g. devlink mon).

why not update the cache on name changes? Doing a query on print has
extra overhead. And, if you insist a per-print query is needed, why
leave ifname_map_list? what value does it serve if you query each time?


> Therefore, query ifname during each devlink port print.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  devlink/devlink.c | 46 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 8aefa101b2f8..680936f891cf 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -864,21 +864,38 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
>  	return -ENOENT;
>  }
>  
> -static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
> -				 const char *dev_name, uint32_t port_index,
> -				 char **p_ifname)
> +static int port_ifname_get_cb(const struct nlmsghdr *nlh, void *data)
>  {
> -	struct ifname_map *ifname_map;
> +	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
> +	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
> +	char **p_ifname = data;
> +	const char *ifname;
>  
> -	list_for_each_entry(ifname_map, &dl->ifname_map_list, list) {
> -		if (strcmp(bus_name, ifname_map->bus_name) == 0 &&
> -		    strcmp(dev_name, ifname_map->dev_name) == 0 &&
> -		    port_index == ifname_map->port_index) {
> -			*p_ifname = ifname_map->ifname;
> -			return 0;
> -		}
> -	}
> -	return -ENOENT;
> +	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
> +	if (!tb[DEVLINK_ATTR_PORT_NETDEV_NAME])
> +		return MNL_CB_ERROR;
> +
> +	ifname = mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_NETDEV_NAME]);
> +	*p_ifname = strdup(ifname);
> +	if (!*p_ifname)
> +		return MNL_CB_ERROR;
> +
> +	return MNL_CB_OK;
> +}
> +
> +static int port_ifname_get(struct dl *dl, const char *bus_name,
> +			   const char *dev_name, uint32_t port_index,
> +			   char **p_ifname)
> +{
> +	struct nlmsghdr *nlh;
> +
> +	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
> +			       NLM_F_REQUEST | NLM_F_ACK);
> +	mnl_attr_put_strz(nlh, DEVLINK_ATTR_BUS_NAME, bus_name);
> +	mnl_attr_put_strz(nlh, DEVLINK_ATTR_DEV_NAME, dev_name);
> +	mnl_attr_put_u32(nlh, DEVLINK_ATTR_PORT_INDEX, port_index);
> +	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, port_ifname_get_cb,
> +				      p_ifname);
>  }
>  
>  static int strtobool(const char *str, bool *p_val)
> @@ -2577,8 +2594,7 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
>  	char *ifname = NULL;
>  
>  	if (dl->no_nice_names || !try_nice ||
> -	    ifname_map_rev_lookup(dl, bus_name, dev_name,
> -				  port_index, &ifname) != 0)
> +	    port_ifname_get(dl, bus_name, dev_name, port_index, &ifname) != 0)
>  		sprintf(buf, "%s/%s/%d", bus_name, dev_name, port_index);
>  	else
>  		sprintf(buf, "%s", ifname);

