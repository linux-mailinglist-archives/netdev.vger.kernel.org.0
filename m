Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AD2A6353
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 10:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfICICD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 04:02:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725888AbfICICD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 04:02:03 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BB045C3910B109BDEAAD;
        Tue,  3 Sep 2019 16:02:00 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Sep 2019
 16:01:55 +0800
Message-ID: <5D6E1DF2.1000109@huawei.com>
Date:   Tue, 3 Sep 2019 16:01:54 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     zhong jiang <zhongjiang@huawei.com>
CC:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hostap: remove set but not used variable 'copied' in
 prism2_io_debug_proc_read
References: <1567497430-22539-1-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1567497430-22539-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore the patch.  Because  the hostap_proc.c is marked as 'obsolete'.

Thanks,
zhong jiang
On 2019/9/3 15:57, zhong jiang wrote:
> Obviously, variable 'copied' is initialized to zero. But it is not used.
> hence just remove it.
>
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/net/wireless/intersil/hostap/hostap_proc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/intersil/hostap/hostap_proc.c b/drivers/net/wireless/intersil/hostap/hostap_proc.c
> index 703d74c..6151d8d 100644
> --- a/drivers/net/wireless/intersil/hostap/hostap_proc.c
> +++ b/drivers/net/wireless/intersil/hostap/hostap_proc.c
> @@ -234,7 +234,7 @@ static int prism2_io_debug_proc_read(char *page, char **start, off_t off,
>  {
>  	local_info_t *local = (local_info_t *) data;
>  	int head = local->io_debug_head;
> -	int start_bytes, left, copy, copied;
> +	int start_bytes, left, copy;
>  
>  	if (off + count > PRISM2_IO_DEBUG_SIZE * 4) {
>  		*eof = 1;
> @@ -243,7 +243,6 @@ static int prism2_io_debug_proc_read(char *page, char **start, off_t off,
>  		count = PRISM2_IO_DEBUG_SIZE * 4 - off;
>  	}
>  
> -	copied = 0;
>  	start_bytes = (PRISM2_IO_DEBUG_SIZE - head) * 4;
>  	left = count;
>  


