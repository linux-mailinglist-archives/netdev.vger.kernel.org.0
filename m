Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4159F10802F
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 20:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKWTzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 14:55:13 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39940 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWTzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 14:55:13 -0500
Received: by mail-pj1-f67.google.com with SMTP id ep1so4639093pjb.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 11:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hX+Wc6fDdEjkXGsBe+9LZoD/JwGte0nyiDLwxqelzTg=;
        b=z5ndaq+19Qu9RkB4tKFWovmRfkjIN4FDI7/FA9mSCKm+aolIdcf3RUaT+Y2OiH8lf0
         4RfDP5NQDxznsRaYsOBhdjV+j5FsF88k9lwoGW0kqC1vnl1gtjgqvrfSSDZqNgSUL63D
         Dep6eFEXQl6MMs2f2S1noIfX42H/tGvsDnFx45pTSMMgWEMn5cGzJVNi5C2PpuJTWE2F
         lErD7AClwnvh8fStA06TPGNFxSCygP3uurdlWvf2tq6CpvlJ+ylMTACsH4h0+OOWP2ct
         Hg7xawxzszV0bJiwIhtmqUXvrCON25pdiXdYGv5CBzBz7wwhceHvKcYGEXSt90zjrtiI
         YVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hX+Wc6fDdEjkXGsBe+9LZoD/JwGte0nyiDLwxqelzTg=;
        b=UphQM40JdauWScnjN/3imKCouIbasnABZvBEwbyRn6r5PDRz4HVcERSQuT1P9DKJ7G
         Zs4E+3n+b4DAB9c9D2KfIb+0z3qAdi21dh+tZRDQb55RUN9kUqMohNV6x+5I0/u/WOgg
         HeAEKXzJX+NjobQFRfWnW45f419RL8JoJ3gN0/k2MdUCgCAV793RgkbM8mfJK89VJUHg
         ihyzFH8FXuBIUkf74RFWAeN1iXuJxYKuBC3I1Q4CrCFQEvEipRTT4bLzaAS7dlDANt3T
         /YNC0j8Rr5ZeQxccYETI+I1EpE2LljxjW4BJPMY4ieANy2hOJtka/QOa1XBjEdWYSACp
         RZZA==
X-Gm-Message-State: APjAAAUvqnX3skQf8BNndBRQrgPsg6XeITho1YoRDNaDfuS44k842n9c
        k6bJD27W0t6UBcDD4gADsQWbVQ==
X-Google-Smtp-Source: APXvYqz/31BMmxOUtbjIzYkS+O9w92u35rN86XAAA3/ISZUb7bW+LjIcaQvBvtDCP/d3v2DLoPBggA==
X-Received: by 2002:a17:90a:8a11:: with SMTP id w17mr27424866pjn.136.1574538912474;
        Sat, 23 Nov 2019 11:55:12 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v10sm2573988pfg.11.2019.11.23.11.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 11:55:12 -0800 (PST)
Date:   Sat, 23 Nov 2019 11:55:06 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 15/15] bnxt_en: Add support for devlink info
 command
Message-ID: <20191123115506.2019cd08@cakuba.netronome.com>
In-Reply-To: <1574497570-22102-16-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
        <1574497570-22102-16-git-send-email-michael.chan@broadcom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 03:26:10 -0500, Michael Chan wrote:
> From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> 
> Display the following information via devlink info command:
>   - Driver name
>   - Board id
>   - Broad revision
>   - Board Serial number
>   - Board Package version
>   - FW version
>   - FW management version
>   - FW RoCE version
> 
>   Standard output example:
>   $ devlink dev info pci/0000:3b:00.0
>   pci/0000:3b:00.0:
>     driver bnxt_en
>     serial_number B0-26-28-FF-FE-25-84-20
>     versions:
>         fixed:
>           board.id C454
>           board.rev 1
>         running:
>           board.package N/A

Just don't report it if you don't have it?

>           fw.version 216.0.154.32004
>           fw.mgmt 864.0.0.0
>           fw.app 216.0.51.0
> 
> Cc: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

> +static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
> +	union devlink_param_value nvm_cfg_ver;
> +	struct hwrm_ver_get_output *ver_resp;
> +	char mgmt_ver[FW_VER_STR_LEN];
> +	char roce_ver[FW_VER_STR_LEN];
> +	char fw_ver[FW_VER_STR_LEN];
> +	char buf[32];
> +	int rc;
> +
> +	rc = devlink_info_driver_name_put(req, DRV_MODULE_NAME);
> +	if (rc)
> +		return rc;
> +
> +	sprintf(buf, "%X", bp->chip_num);
> +	rc = devlink_info_version_fixed_put(req, "board.id", buf);

Are you sure chip_num is the board id and not the asic id?
Is this the board version or the silicon version?

Also please use the defines: DEVLINK_INFO_VERSION_GENERIC_BOARD_ID.

> +	if (rc)
> +		return rc;
> +
> +	ver_resp = &bp->ver_resp;
> +	sprintf(buf, "%X", ver_resp->chip_rev);
> +	rc = devlink_info_version_fixed_put(req, "board.rev", buf);
> +	if (rc)
> +		return rc;
> +
> +	if (BNXT_PF(bp)) {
> +		sprintf(buf, "%02X-%02X-%02X-%02X-%02X-%02X-%02X-%02X",
> +			bp->dsn[7], bp->dsn[6], bp->dsn[5], bp->dsn[4],
> +			bp->dsn[3], bp->dsn[2], bp->dsn[1], bp->dsn[0]);
> +		rc = devlink_info_serial_number_put(req, buf);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (strlen(ver_resp->active_pkg_name)) {
> +		rc =
> +		    devlink_info_version_running_put(req, "board.package",
> +						     ver_resp->active_pkg_name);

What's a board package? What HW people call a "module"? All devlink info
versions should be documented in devlink-info-versions.rst.

What are the possible values here? Reporting free form strings read
from FW is going to be a tough sell. Probably worth dropping this one
if you want the rest merged for 5.5.

> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
> +		u32 ver = nvm_cfg_ver.vu32;
> +
> +		sprintf(buf, "%X.%X.%X", (ver >> 16) & 0xF, (ver >> 8) & 0xF,
> +			ver & 0xF);
> +		rc = devlink_info_version_running_put(req, "board.nvm_cfg_ver",

ditto

> +						      buf);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (ver_resp->flags & VER_GET_RESP_FLAGS_EXT_VER_AVAIL) {
> +		snprintf(fw_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
> +			 ver_resp->hwrm_fw_major, ver_resp->hwrm_fw_minor,
> +			 ver_resp->hwrm_fw_build, ver_resp->hwrm_fw_patch);
> +
> +		snprintf(mgmt_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
> +			 ver_resp->mgmt_fw_major, ver_resp->mgmt_fw_minor,
> +			 ver_resp->mgmt_fw_build, ver_resp->mgmt_fw_patch);
> +
> +		snprintf(roce_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
> +			 ver_resp->roce_fw_major, ver_resp->roce_fw_minor,
> +			 ver_resp->roce_fw_build, ver_resp->roce_fw_patch);
> +	} else {
> +		snprintf(fw_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
> +			 ver_resp->hwrm_fw_maj_8b, ver_resp->hwrm_fw_min_8b,
> +			 ver_resp->hwrm_fw_bld_8b, ver_resp->hwrm_fw_rsvd_8b);
> +
> +		snprintf(mgmt_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
> +			 ver_resp->mgmt_fw_maj_8b, ver_resp->mgmt_fw_min_8b,
> +			 ver_resp->mgmt_fw_bld_8b, ver_resp->mgmt_fw_rsvd_8b);
> +
> +		snprintf(roce_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
> +			 ver_resp->roce_fw_maj_8b, ver_resp->roce_fw_min_8b,
> +			 ver_resp->roce_fw_bld_8b, ver_resp->roce_fw_rsvd_8b);
> +	}
> +	rc = devlink_info_version_running_put(req, "fw.version", fw_ver);
> +	if (rc)
> +		return rc;
> +
> +	if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
> +		rc = devlink_info_version_running_put(req, "fw.mgmt", mgmt_ver);
> +		if (rc)
> +			return rc;
> +
> +		rc = devlink_info_version_running_put(req, "fw.app", roce_ver);

Should this be fw.roce? Is the NIC ROCE centric, IOW the data path is
all ROCE? 

What's hwrm? perhaps that's the datapath microcode version?

> +		if (rc)
> +			return rc;
> +	}
> +	return 0;
> +}
> +
>  static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
>  			     int msg_len, union devlink_param_value *val)
>  {
