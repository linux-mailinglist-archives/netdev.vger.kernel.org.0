Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020E4303571
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387702AbhAZFlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbhAZEXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 23:23:14 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5512C061573
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:22:34 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id v1so15072257ott.10
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+71kVpH7e3NkfcR/YReIM3Qg42vh5Tdnoamk96i2uW4=;
        b=ORzoIFlfX5G234tbb1uzGfyrKmnes0kmDxGUbRRZ6b2Ql7tkJlvh2rNUxiP/NAI0Xz
         EQELT3qEG8G5F9+0Qwh0yk8zxkFRZMAJSh2UBgdY4p4MdFbyp8Vqr64yrEyWp47ZG1J8
         /dSdRy5EhXRcRHFwxd0WdZlbvlvhR2LcqoBxUvwZBVNmAhj4uir9TzWUDBMLPFRrznQK
         jYoTafhTZCSSfTRrN5l7zV8WLVV2FuX3ecgDhfxaLeFFCWRDgFRywx5DMkinZ9YW3ExZ
         sLM5ECuT0SxMxmPJ4kYPWx8kD4rUOMIqRC9+IYSxoSgN5PaWqd9XJsH87R8/6bVjmmpS
         0GGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+71kVpH7e3NkfcR/YReIM3Qg42vh5Tdnoamk96i2uW4=;
        b=hRr5BhzyzJ5jHjKz78+YFdia5Jk7RZwlrFR0e4g7inWWVyzQT4O+ILWe49oqnO2WJ9
         Z/R/4yg4NFvmc9QCadPNWH7dugHfmNy3c/mNG+oOvpX5Jbmr7aS+gnpRv4aVCdNXIXD9
         q6Jvt7lK4Lz7actXNRdbEnl+kjskSG92W7wcGmqnuVgDLxmed70k5SbD4mHmPQO6+jrb
         G0y5ysYXrfUw4ifpxuVF8W5k/rS79EGzI9u+tnC39ZkZfiNlpHTk+8otcbV4snc83KRJ
         5STmM3obq/T3Y3J5iMekq4yd/DOPsXskpWcf/NN2SjxjCttConKKSTUgon0/qVtnotju
         q7LQ==
X-Gm-Message-State: AOAM530YHH95MK+7UWGFyZaFL72Bk4ZAJ1y18vPfEs0P2ltw8md721RL
        SWD4WRu0r7wyi5fD/1LJMYY=
X-Google-Smtp-Source: ABdhPJz8dSZOMmbbmrg1v7N3OMYJza7i3D+SGcGzdRrqKLZVxcu6x2n7XAXWKmZp1DKIrDNpjdjX6Q==
X-Received: by 2002:a9d:3b43:: with SMTP id z61mr2753282otb.217.1611634953934;
        Mon, 25 Jan 2021 20:22:33 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f5f4:6dbf:d358:29ee])
        by smtp.googlemail.com with ESMTPSA id z3sm3737994ooj.26.2021.01.25.20.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 20:22:33 -0800 (PST)
Subject: Re: [PATCH iproute2-next 2/2] vdpa: Add vdpa tool
To:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stephen@networkplumber.org, mst@redhat.com, jasowang@redhat.com
References: <20210122112654.9593-1-parav@nvidia.com>
 <20210122112654.9593-3-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dc59454f-5e8b-2fce-9837-44808df933d4@gmail.com>
Date:   Mon, 25 Jan 2021 21:22:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122112654.9593-3-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks fine. A few comments below around code re-use.

On 1/22/21 4:26 AM, Parav Pandit wrote:
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> new file mode 100644
> index 00000000..942524b7
> --- /dev/null
> +++ b/vdpa/vdpa.c
> @@ -0,0 +1,828 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include <stdio.h>
> +#include <getopt.h>
> +#include <errno.h>
> +#include <linux/genetlink.h>
> +#include <linux/vdpa.h>
> +#include <linux/virtio_ids.h>
> +#include <linux/netlink.h>
> +#include <libmnl/libmnl.h>
> +#include "mnl_utils.h"
> +
> +#include "version.h"
> +#include "json_print.h"
> +#include "utils.h"
> +
> +static int g_indent_level;
> +
> +#define INDENT_STR_STEP 2
> +#define INDENT_STR_MAXLEN 32
> +static char g_indent_str[INDENT_STR_MAXLEN + 1] = "";

The indent code has a lot of parallels with devlink -- including helpers
below around indent_inc and _dec. Please take a look at how to refactor
and re-use.

> +
> +struct vdpa_socket {
> +	struct mnl_socket *nl;
> +	char *buf;
> +	uint32_t family;
> +	unsigned int seq;
> +};
> +
> +static int vdpa_socket_sndrcv(struct vdpa_socket *nlg, const struct nlmsghdr *nlh,
> +			      mnl_cb_t data_cb, void *data)
> +{
> +	int err;
> +
> +	err = mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
> +	if (err < 0) {
> +		perror("Failed to send data");
> +		return -errno;
> +	}
> +
> +	err = mnlu_socket_recv_run(nlg->nl, nlh->nlmsg_seq, nlg->buf, MNL_SOCKET_BUFFER_SIZE,
> +				   data_cb, data);
> +	if (err < 0) {
> +		fprintf(stderr, "vdpa answers: %s\n", strerror(errno));
> +		return -errno;
> +	}
> +	return 0;
> +}
> +
> +static int get_family_id_attr_cb(const struct nlattr *attr, void *data)
> +{
> +	int type = mnl_attr_get_type(attr);
> +	const struct nlattr **tb = data;
> +
> +	if (mnl_attr_type_valid(attr, CTRL_ATTR_MAX) < 0)
> +		return MNL_CB_ERROR;
> +
> +	if (type == CTRL_ATTR_FAMILY_ID &&
> +	    mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
> +		return MNL_CB_ERROR;
> +	tb[type] = attr;
> +	return MNL_CB_OK;
> +}
> +
> +static int get_family_id_cb(const struct nlmsghdr *nlh, void *data)
> +{
> +	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
> +	struct nlattr *tb[CTRL_ATTR_MAX + 1] = {};
> +	uint32_t *p_id = data;
> +
> +	mnl_attr_parse(nlh, sizeof(*genl), get_family_id_attr_cb, tb);
> +	if (!tb[CTRL_ATTR_FAMILY_ID])
> +		return MNL_CB_ERROR;
> +	*p_id = mnl_attr_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
> +	return MNL_CB_OK;
> +}
> +
> +static int family_get(struct vdpa_socket *nlg)
> +{
> +	struct genlmsghdr hdr = {};
> +	struct nlmsghdr *nlh;
> +	int err;
> +
> +	hdr.cmd = CTRL_CMD_GETFAMILY;
> +	hdr.version = 0x1;
> +
> +	nlh = mnlu_msg_prepare(nlg->buf, GENL_ID_CTRL,
> +			       NLM_F_REQUEST | NLM_F_ACK,
> +			       &hdr, sizeof(hdr));
> +
> +	mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, VDPA_GENL_NAME);
> +
> +	err = mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
> +	if (err < 0)
> +		return err;
> +
> +	err = mnlu_socket_recv_run(nlg->nl, nlh->nlmsg_seq, nlg->buf,
> +				   MNL_SOCKET_BUFFER_SIZE,
> +				   get_family_id_cb, &nlg->family);
> +	return err;
> +}
> +
> +static int vdpa_socket_open(struct vdpa_socket *nlg)
> +{
> +	int err;
> +
> +	nlg->buf = malloc(MNL_SOCKET_BUFFER_SIZE);
> +	if (!nlg->buf)
> +		goto err_buf_alloc;
> +
> +	nlg->nl = mnlu_socket_open(NETLINK_GENERIC);
> +	if (!nlg->nl)
> +		goto err_socket_open;
> +
> +	err = family_get(nlg);
> +	if (err)
> +		goto err_socket;
> +
> +	return 0;
> +
> +err_socket:
> +	mnl_socket_close(nlg->nl);
> +err_socket_open:
> +	free(nlg->buf);
> +err_buf_alloc:
> +	return -1;
> +}

The above 4 functions duplicate a lot of devlink functionality. Please
create a helper in lib/mnl_utils.c that can be used in both.

> +
> +static void vdpa_socket_close(struct vdpa_socket *nlg)
> +{
> +	mnl_socket_close(nlg->nl);
> +	free(nlg->buf);
> +}
> +
> +#define VDPA_OPT_MGMTDEV_HANDLE		BIT(0)
> +#define VDPA_OPT_VDEV_MGMTDEV_HANDLE	BIT(1)
> +#define VDPA_OPT_VDEV_NAME 		BIT(2)
> +#define VDPA_OPT_VDEV_HANDLE 		BIT(3)
> +
> +struct vdpa_opts {
> +	uint64_t present; /* flags of present items */
> +	const char *mdev_bus_name;
> +	const char *mdev_name;
> +	const char *vdev_name;
> +	unsigned int device_id;
> +};
> +
> +struct vdpa {
> +	struct vdpa_socket nlg;
> +	struct vdpa_opts opts;
> +	bool json_output;
> +};
> +
> +static void indent_inc(void)
> +{
> +	if (g_indent_level + INDENT_STR_STEP > INDENT_STR_MAXLEN)
> +		return;
> +	g_indent_level += INDENT_STR_STEP;
> +	memset(g_indent_str, ' ', sizeof(g_indent_str));
> +	g_indent_str[g_indent_level] = '\0';
> +}
> +
> +static void indent_dec(void)
> +{
> +	if (g_indent_level - INDENT_STR_STEP < 0)
> +		return;
> +	g_indent_level -= INDENT_STR_STEP;
> +	g_indent_str[g_indent_level] = '\0';
> +}
> +
> +static void indent_print(void)
> +{
> +	if (g_indent_level)
> +		printf("%s", g_indent_str);
> +}
> +
> +static void pr_out_section_start(struct vdpa *vdpa, const char *name)
> +{
> +	open_json_object(NULL);
> +	open_json_object(name);
> +}
> +
> +static void pr_out_section_end(struct vdpa *vdpa)
> +{
> +	close_json_object();
> +	close_json_object();
> +}
> +
> +static void pr_out_array_start(struct vdpa *vdpa, const char *name)
> +{
> +	if (!vdpa->json_output) {
> +		print_nl();
> +		indent_inc();
> +		indent_print();
> +	}
> +	open_json_array(PRINT_ANY, name);
> +}
> +
> +static void pr_out_array_end(struct vdpa *vdpa)
> +{
> +	close_json_array(PRINT_JSON, NULL);
> +	if (!vdpa->json_output)
> +		indent_dec();
> +}
> +
> +static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> +	[VDPA_ATTR_MGMTDEV_BUS_NAME] = MNL_TYPE_NUL_STRING,
> +	[VDPA_ATTR_MGMTDEV_DEV_NAME] = MNL_TYPE_NUL_STRING,
> +	[VDPA_ATTR_DEV_NAME] = MNL_TYPE_STRING,
> +	[VDPA_ATTR_DEV_ID] = MNL_TYPE_U32,
> +	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
> +	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
> +	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> +};
> +
> +static int attr_cb(const struct nlattr *attr, void *data)
> +{
> +	const struct nlattr **tb = data;
> +	int type;
> +
> +	if (mnl_attr_type_valid(attr, VDPA_ATTR_MAX) < 0)
> +		return MNL_CB_OK;
> +
> +	type = mnl_attr_get_type(attr);
> +	if (mnl_attr_validate(attr, vdpa_policy[type]) < 0)
> +		return MNL_CB_ERROR;
> +
> +	tb[type] = attr;
> +	return MNL_CB_OK;
> +}
> +
> +static unsigned int strslashcount(char *str)
> +{
> +	unsigned int count = 0;
> +	char *pos = str;
> +
> +	while ((pos = strchr(pos, '/'))) {
> +		count++;
> +		pos++;
> +	}
> +	return count;
> +}

you could make that a generic function (e.g., str_char_count) by passing
'/' as an input.

> +
> +static int strslashrsplit(char *str, const char **before, const char **after)
> +{
> +	char *slash;
> +
> +	slash = strrchr(str, '/');
> +	if (!slash)
> +		return -EINVAL;
> +	*slash = '\0';
> +	*before = str;
> +	*after = slash + 1;
> +	return 0;
> +}

similarly here. If you start with things like this in lib/utils you make
it easier for follow on users to find.


