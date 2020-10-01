Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019B327F7E7
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 04:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgJACSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 22:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbgJACSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 22:18:02 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46E0C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 19:18:02 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l126so2959223pfd.5
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 19:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=Z9qE8uetHSNY5pUKZ2lfhQvTyhk+B3AqrYNoaNuPPrU=;
        b=LJBNQcsxmIV/HhoqS4Zl15kagRb4FhJIXarYoZk5gDyh7f4jS4anNcD/xfR40kHcWY
         842209RH5BvBC1kcmhnZSFhSe7I5AP2F7wsP3FPcAQSWmGrwmQ6U6nWTlrn8gPql8eYQ
         cZg2IiWZU5g9JL+Utm8vWwSL2xPiVPH1AFVvct6tCyF1LU9A5iSJIy3+Xj76lzde0iRN
         e4d/aCJQK1nap7nhqXIa5Ts5aLRLRYkQQnMbWGsIx6TBSH0DkyskROx3gNZfTx482OiE
         NiFjPq2HIkPh7oeDPK3KqbrXrmqerJ6w6Gc/mESZoU/PNCMPu0s+4iH08mMCyMBMSA6T
         O91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Z9qE8uetHSNY5pUKZ2lfhQvTyhk+B3AqrYNoaNuPPrU=;
        b=T9a9CpQM57E3maS7u+ClupWclq62rz3hl3+QBR/RchI0Mzw83t5UfpJgrJ7H/2d7Fc
         FkypBkZEH9ivaZ7MSCwi6QwINn4Lh0WpXXVwA45vjEuxUv6xouY62j4hyfN6kDFEjKhd
         6iInThRmLgMc7g6DwL5uN7ZaaKHJ9tYLyTuILmzAxZ/hVC8WhQslYw5N/Swp+9RcvzqH
         mUTvD2aegXj0dO7bx8ugdgo0d+K0+KT/GSkdx6GYBSCUrXDC7gGGaB5ofwS4qFXB5MPM
         rCzSonrAefZvsLdHaBJlNbIOt4eNyJo0HpRVPDpnKqVv4YFeVZlksGzlDjiSBvFcPMi1
         Sp/A==
X-Gm-Message-State: AOAM533VDJE4VAeF872ifqOvqLcz18nZEyBXXlXKhMfXu5569Gf7tPzS
        NVjk2MI+ttM7DfvxJ1E2nWCFYTQbEI/RwQ==
X-Google-Smtp-Source: ABdhPJy1aoZWCIpSMArww893j7K2MPiG24grxDqHx/5i+0mQB/ZzTKCNAkc2Vl3tdQSKUZo4gYoiQA==
X-Received: by 2002:aa7:8146:0:b029:152:10aa:2dbb with SMTP id d6-20020aa781460000b029015210aa2dbbmr20330pfn.3.1601518681909;
        Wed, 30 Sep 2020 19:18:01 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id ih11sm3412181pjb.51.2020.09.30.19.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 19:18:01 -0700 (PDT)
Subject: Re: [iproute2-next v2 1/1] devlink: display elapsed time during flash
 update
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20200930234012.137020-1-jacob.e.keller@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3180c80b-5d53-abd3-4929-3282cae526b4@pensando.io>
Date:   Wed, 30 Sep 2020 19:18:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200930234012.137020-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 4:40 PM, Jacob Keller wrote:
> For some devices, updating the flash can take significant time during
> operations where no status can meaningfully be reported. This can be
> somewhat confusing to a user who sees devlink appear to hang on the
> terminal waiting for the device to update.
>
> Recent changes to the kernel interface allow such long running commands
> to provide a timeout value indicating some upper bound on how long the
> relevant action could take.
>
> Provide a ticking counter of the time elapsed since the previous status
> message in order to make it clear that the program is not simply stuck.
>
> Display this message whenever the status message from the kernel
> indicates a timeout value. Additionally also display the message if
> we've received no status for more than couple of seconds. If we elapse
> more than the timeout provided by the status message, replace the
> timeout display with "timeout reached".
>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Works for me - thanks!

Tested-by: Shannon Nelson <snelson@pensando.io>


> ---
>
> Changes since v1
> * update last status time only when the message changes, allowing an elapsed
>    time to represent the full operation of downloading or programming the
>    image.
> * Use "\b \b" to erase the elapsed time message properly even when we will
>    not be printing new text over it. This ensures that the messages disappear
>    as intended when we move to a new line.
>
> Because this is a bit confusing to understand the behavior when looking
> purely at text logs, I captured video of an update with this patch set and
> have posted it at [1] in case reviewers would like to actually see behavior
> in action
>
> [1] https://youtu.be/aeVuQzK0Lo8
>
>   devlink/devlink.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 98 insertions(+), 1 deletion(-)
>
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 0374175eda3d..aae5055e2c71 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -33,6 +33,7 @@
>   #include <sys/select.h>
>   #include <sys/socket.h>
>   #include <sys/types.h>
> +#include <sys/time.h>
>   #include <rt_names.h>
>   
>   #include "version.h"
> @@ -3066,6 +3067,9 @@ static int cmd_dev_info(struct dl *dl)
>   
>   struct cmd_dev_flash_status_ctx {
>   	struct dl *dl;
> +	struct timeval time_of_last_status;
> +	uint64_t status_msg_timeout;
> +	size_t elapsed_time_msg_len;
>   	char *last_msg;
>   	char *last_component;
>   	uint8_t not_first:1,
> @@ -3083,6 +3087,16 @@ static int nullstrcmp(const char *str1, const char *str2)
>   	return str1 ? 1 : -1;
>   }
>   
> +static void cmd_dev_flash_clear_elapsed_time(struct cmd_dev_flash_status_ctx *ctx)
> +{
> +	int i;
> +
> +	for (i = 0; i < ctx->elapsed_time_msg_len; i++)
> +		pr_out_tty("\b \b");
> +
> +	ctx->elapsed_time_msg_len = 0;
> +}
> +
>   static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
>   {
>   	struct cmd_dev_flash_status_ctx *ctx = data;
> @@ -3095,6 +3109,8 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
>   	const char *bus_name;
>   	const char *dev_name;
>   
> +	cmd_dev_flash_clear_elapsed_time(ctx);
> +
>   	if (genl->cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS &&
>   	    genl->cmd != DEVLINK_CMD_FLASH_UPDATE_END)
>   		return MNL_CB_STOP;
> @@ -3124,12 +3140,19 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
>   		done = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE]);
>   	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL])
>   		total = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL]);
> +	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT])
> +		ctx->status_msg_timeout = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT]);
> +	else
> +		ctx->status_msg_timeout = 0;
>   
>   	if (!nullstrcmp(msg, ctx->last_msg) &&
>   	    !nullstrcmp(component, ctx->last_component) &&
>   	    ctx->last_pc && ctx->not_first) {
>   		pr_out_tty("\b\b\b\b\b"); /* clean percentage */
>   	} else {
> +		/* only update the last status timestamp if the message changed */
> +		gettimeofday(&ctx->time_of_last_status, NULL);
> +
>   		if (ctx->not_first)
>   			pr_out("\n");
>   		if (component) {
> @@ -3155,11 +3178,72 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
>   	return MNL_CB_STOP;
>   }
>   
> +static void cmd_dev_flash_time_elapsed(struct cmd_dev_flash_status_ctx *ctx)
> +{
> +	struct timeval now, res;
> +
> +	gettimeofday(&now, NULL);
> +	timersub(&now, &ctx->time_of_last_status, &res);
> +
> +	/* Only begin displaying an elapsed time message if we've waited a few
> +	 * seconds with no response, or the status message included a timeout
> +	 * value.
> +	 */
> +	if (res.tv_sec > 2 || ctx->status_msg_timeout) {
> +		uint64_t elapsed_m, elapsed_s;
> +		char msg[128];
> +		size_t len;
> +
> +		/* clear the last elapsed time message, if we have one */
> +		cmd_dev_flash_clear_elapsed_time(ctx);
> +
> +		elapsed_m = res.tv_sec / 60;
> +		elapsed_s = res.tv_sec % 60;
> +
> +		/**
> +		 * If we've elapsed a few seconds without receiving any status
> +		 * notification from the device, we display a time elapsed
> +		 * message. This has a few possible formats:
> +		 *
> +		 * 1) just time elapsed, when no timeout was provided
> +		 *    " ( Xm Ys )"
> +		 * 2) time elapsed out of a timeout that came from the device
> +		 *    driver via DEVLINK_CMD_FLASH_UPDATE_STATUS_TIMEOUT
> +		 *    " ( Xm Ys : Am Ys)"
> +		 * 3) time elapsed if we still receive no status after
> +		 *    reaching the provided timeout.
> +		 *    " ( Xm Ys : timeout reached )"
> +		 */
> +		if (!ctx->status_msg_timeout) {
> +			len = snprintf(msg, sizeof(msg),
> +				       " ( %lum %lus )", elapsed_m, elapsed_s);
> +		} else if (res.tv_sec <= ctx->status_msg_timeout) {
> +			uint64_t timeout_m, timeout_s;
> +
> +			timeout_m = ctx->status_msg_timeout / 60;
> +			timeout_s = ctx->status_msg_timeout % 60;
> +
> +			len = snprintf(msg, sizeof(msg),
> +				       " ( %lum %lus : %lum %lus )",
> +				       elapsed_m, elapsed_s, timeout_m, timeout_s);
> +		} else {
> +			len = snprintf(msg, sizeof(msg),
> +				       " ( %lum %lus : timeout reached )", elapsed_m, elapsed_s);
> +		}
> +
> +		ctx->elapsed_time_msg_len = len;
> +
> +		pr_out_tty("%s", msg);
> +		fflush(stdout);
> +	}
> +}
> +
>   static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
>   				     struct mnlg_socket *nlg_ntf,
>   				     int pipe_r)
>   {
>   	int nlfd = mnlg_socket_get_fd(nlg_ntf);
> +	struct timeval timeout;
>   	fd_set fds[3];
>   	int fdmax;
>   	int i;
> @@ -3174,7 +3258,14 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
>   	if (nlfd >= fdmax)
>   		fdmax = nlfd + 1;
>   
> -	while (select(fdmax, &fds[0], &fds[1], &fds[2], NULL) < 0) {
> +	/* select only for a short while (1/10th of a second) in order to
> +	 * allow periodically updating the screen with an elapsed time
> +	 * indicator.
> +	 */
> +	timeout.tv_sec = 0;
> +	timeout.tv_usec = 100000;
> +
> +	while (select(fdmax, &fds[0], &fds[1], &fds[2], &timeout) < 0) {
>   		if (errno == EINTR)
>   			continue;
>   		pr_err("select() failed\n");
> @@ -3196,6 +3287,7 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
>   			return err2;
>   		ctx->flash_done = 1;
>   	}
> +	cmd_dev_flash_time_elapsed(ctx);
>   	return 0;
>   }
>   
> @@ -3256,6 +3348,11 @@ static int cmd_dev_flash(struct dl *dl)
>   	}
>   	close(pipe_w);
>   
> +	/* initialize starting time to allow comparison for when to begin
> +	 * displaying a time elapsed message.
> +	 */
> +	gettimeofday(&ctx.time_of_last_status, NULL);
> +
>   	do {
>   		err = cmd_dev_flash_fds_process(&ctx, nlg_ntf, pipe_r);
>   		if (err)

