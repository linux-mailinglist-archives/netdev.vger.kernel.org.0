Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774A51949F3
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgCZVK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:10:59 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:53425 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbgCZVK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:10:58 -0400
Received: by mail-wm1-f47.google.com with SMTP id b12so8703766wmj.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yygxz4rTGLO712h67O68fKQohIpoTQ1yw0nxF7pQyIM=;
        b=JQUDxGSGkYZKGxp6xkExcc7SxyOKsCcugeyjYhcbTZZP7mhNraRRS2DcTj/oJBMr1B
         RyivQjC28iKdAI602MmymUcM9ZrnZOqhttOcUftOFe+rpsisJzUbtq7Bk8vOlTWMXanw
         YrjAmEmolhQbHu2fSWfEdJEoiy0CQlKH7njiHQALvA0Xkn+AO7WpsdkZXpUPjy9LCF0g
         HTewcYBG5o/tTEHV9r4xGXh0+eEyORY8pgk64pShj8cVj+j9q03x3WWTAW/G7m4ebNyQ
         gwhHLKK9hNXGKj+L3oKvDfQ0oDRC2JX8SYgt1fyaI0TpirGyOp8QpSMdvOWdarJH3q2I
         NEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yygxz4rTGLO712h67O68fKQohIpoTQ1yw0nxF7pQyIM=;
        b=XQY4b4qAqYTpGm+0WICQPT+2cifRsHDct34GSagWaDXDghTr6eaxYEWD9u6lIfSfIk
         NPUdSQMukxFWByYDUbc07wCHr8j4Vhuw83/2G6ywWXSaxHL0f0SWV9BsoICYY+RJlABL
         U/G76qvO8VCcCGg3up/oqS+VfhA7WtaSdiKp7zHtRCZBg2gYvymIKFQufAp6BwBKja+R
         FIjzdkRlnBig9q7l1ZVCu7FpCPWlnepxLhB1fm62jTRfXxrZHx69mjNRvNxwtwj50OTc
         4qcNY1j/WxlmYcpLVXOS6lmLcDGeJAP9x7PJ53aPUv1U6lVav1Z7BiGjnuxFeOPP8mv7
         JTWg==
X-Gm-Message-State: ANhLgQ0PSGDGgvMsYnLez/tpnx5Fh47RPpEz1m6AI1pe8OKw+oRUbvsH
        +seZ4Pgvpv0FfRs/wiOwGy8xAw==
X-Google-Smtp-Source: ADFU+vtxmBmN5Uoah+pCky8OkpkM/A8f3S9MMj/lZNkNYvJIn3WVXF4rQgQF/MO91vLhQ3EKc7bxqQ==
X-Received: by 2002:a7b:c764:: with SMTP id x4mr1990259wmk.39.1585257056354;
        Thu, 26 Mar 2020 14:10:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 23sm4700468wmj.34.2020.03.26.14.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:10:55 -0700 (PDT)
Date:   Thu, 26 Mar 2020 22:10:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 09/11] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200326211054.GA11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-10-jacob.e.keller@intel.com>
 <20200326085239.GO11304@nanopsycho.orion>
 <5fe502ca-8b67-673c-150a-86a28938faad@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fe502ca-8b67-673c-150a-86a28938faad@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 05:19:30PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 3/26/2020 1:52 AM, Jiri Pirko wrote:
>> Thu, Mar 26, 2020 at 04:51:55AM CET, jacob.e.keller@intel.com wrote:
>> 
>> [...]
>> 
>>> +	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>>> +	if (err) {
>>> +		return err;
>>> +	}
>>> +
>>> +	err = region->ops->snapshot(devlink, info->extack, &data);
>>> +	if (err)
>>> +		goto snapshot_capture_failure;
>>> +
>>> +	err = __devlink_region_snapshot_create(region, data, snapshot_id);
>>> +	if (err)
>>> +		goto snapshot_create_failure;
>>> +
>>> +	return 0;
>>> +
>>> +snapshot_create_failure:
>>> +	region->ops->destructor(data);
>>> +snapshot_capture_failure:
>> 
>> Eh, this actually should be "err_snapshot_capture" and
>> "err_snapshot_create"
>> 
>
>Sure. It seems a lot of functions use "out" or "nla_put_failure", or

yeah, "nla_put_failure" is a special kind that is used through the net
code.


>other styles.
>
>$grep "^[A-Za-z0-9_]*:" net/core/devlink.c | sort | uniq -c | less
>      1 dump_err:
>      1 err_action_value_put:
>      1 err_action_values_put:
>      1 err_cancel_msg:
>      1 err_group_init:
>      1 err_group_link:
>      1 err_match_value_put:
>      1 err_match_values_put:
>      1 err_resource_put:
>      2 err_stats_alloc:
>      2 err_table_put:
>      1 err_trap_fill:
>      1 err_trap_group_fill:
>      1 err_trap_group_register:
>      1 err_trap_group_verify:
>      1 err_trap_init:
>      1 err_trap_register:
>      1 err_trap_verify:
>      1 free_msg:
>      2 genlmsg_cancel:
>      1 id_increment_failure:
>     34 nla_put_failure:
>      1 nla_put_failure_type_locked:
>     27 out:
>      1 out_cancel_msg:
>      1 out_dev:
>      2 out_free_msg:
>      1 out_unlock:
>      1 param_nest_cancel:
>      1 reporter_nest_cancel:
>      1 resource_put_failure:
>      1 rollback:
>      4 send_done:
>      1 snapshot_capture_failure:
>      1 snapshot_create_failure:
>      3 start_again:
>      9 unlock:
>      1 value_nest_cancel:
>      1 values_list_nest_cancel:
>
>But I'll change these.
