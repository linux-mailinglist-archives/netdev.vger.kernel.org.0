Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF8585ACD
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 08:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbfHHGax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 02:30:53 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:58963 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfHHGax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 02:30:53 -0400
Received: from heimpold-pc.localnet ([109.104.52.1]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1Mi27T-1iYoNQ0DDt-00e2OF; Thu, 08 Aug 2019 08:30:45 +0200
From:   Michael Heimpold <michael.heimpold@i2se.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: Re: [PATCH 11/17] qca: no need to check return value of debugfs_create functions
Date:   Thu, 08 Aug 2019 08:30:43 +0200
Message-ID: <2169368.OBVzby0tpl@heimpold-pc>
Organization: I2SE GmbH
In-Reply-To: <20190806161128.31232-12-gregkh@linuxfoundation.org>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org> <20190806161128.31232-12-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:tXCVQTC/EsKqthred35hucXs6u/3X9JIHizQHHVZ+Zwoz/bJI+y
 0asTBu248U1FFKfOpA3k/T0x3BlU2o7zuvckUHdzJ2DT7B7CEXioKxOpFruHEYN/R7Ra5pM
 7VLjxt9TEfXUFYYLKsEcTMgobQmth8TF5Fs7645fD5VzjXujuCnK5lumvpxrCs94R3GjBi5
 OwGB9xme5NtQMuyx8YFOg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xajjXm82mvk=:HY5LQz7tlxCfbt4YSZuiLm
 BeijIj+2Ag3g5Hi6jT9iGpgPZkC/o8MNctmI6nO3jtrCNvruKbsVCKf4Klw37YPSnEFfM+j7h
 BeyouiqnQ6+KwoHpoUnV1IF+k8Pc4QwbsAPNguvx4h9I6CCdxOxtkzZUBofBBqk/yGjhZXXPm
 7dV4PY6+zgxzC5ChszGru2j2AeZ05xBSD7IbqkXH4LQ3CcSS7yV3zDhixLTvwO0z3YJ9WGOWH
 PnCH5QzRmtEeMbnKfdyWokZsdYBqXBgsdYw06pk1ZlwhIAUwMaVjYjF3khacls93Ou77oISG9
 WuCUKQSp2uvTLZg413+9gg7GWDky5m41EyD1esEGUcD1mfQBCWm4aNFQ+i79dmq9y87UOhqEi
 63w2coaT7a5XtxUu73iC4BKN7HGcSaYEs4k2htck10U5+fuSaiAjft+/kegGSy9BpT7/t0J8j
 YP2Idp5dVjEbji8Iewt6U8ywUqQZSSL1ezqSPhletNxLBpGtKpJmyxsYzdAMz/yf98Bb3sXpD
 yXpkGITaxDmLc0Wja1wx2qhTZDfB/1EAu7S1AN1AzxciyJECiSo9Htjbliu1qWtxCquoJ+2oP
 5hJ3TT9m1wn44BOnH73Xc2WbTRcZjAhnFFbn7eSt7zLGzYT74U7Mv60RW3AqM65MIIonJ81xc
 GJBe+uA+y1EcRJFsz/ucoJuJGinHsvuDU5pzksgsotFnr3xm0uzZgbKh14gujyKUGX0RMYOQc
 pvkI454gzdZ4Dmz8ZxXdsFe4usZX2306F/VKNi0TkYXVMXKpVoB6f2mF1CD3v2YUaFNzKwaKf
 wRmks6Z
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, 6. August 2019, 18:11:22 CEST schrieb Greg Kroah-Hartman:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Stefan Wahren <stefan.wahren@i2se.com>
> Cc: Michael Heimpold <michael.heimpold@i2se.com>
> Cc: Yangtao Li <tiny.windzz@gmail.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/ethernet/qualcomm/qca_debug.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c
> b/drivers/net/ethernet/qualcomm/qca_debug.c index
> bcb890b18a94..702aa217a27a 100644
> --- a/drivers/net/ethernet/qualcomm/qca_debug.c
> +++ b/drivers/net/ethernet/qualcomm/qca_debug.c
> @@ -131,17 +131,10 @@ DEFINE_SHOW_ATTRIBUTE(qcaspi_info);
>  void
>  qcaspi_init_device_debugfs(struct qcaspi *qca)
>  {
> -	struct dentry *device_root;
> +	qca->device_root = debugfs_create_dir(dev_name(&qca->net_dev->dev),
> +					      NULL);
> 
> -	device_root = debugfs_create_dir(dev_name(&qca->net_dev->dev), NULL);
> -	qca->device_root = device_root;
> -
> -	if (IS_ERR(device_root) || !device_root) {
> -		pr_warn("failed to create debugfs directory for %s\n",
> -			dev_name(&qca->net_dev->dev));
> -		return;
> -	}
> -	debugfs_create_file("info", S_IFREG | 0444, device_root, qca,
> +	debugfs_create_file("info", S_IFREG | 0444, qca->device_root, qca,
>  			    &qcaspi_info_fops);
>  }

Acked-by: Michael Heimpold <michael.heimpold@i2se.com>




