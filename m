Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C9047A644
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbhLTIv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:51:29 -0500
Received: from s-terra.s-terra.com ([213.5.74.59]:42417 "EHLO
        s-terra.s-terra.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbhLTIv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 03:51:28 -0500
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Dec 2021 03:51:28 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-terra.ru; s=mail;
        t=1639989692; bh=RBxMx2kr2WNMU5UkLD+REnyr7LQwrSl5bIa/juFO88Q=;
        h=To:From:Date:From;
        b=Ya5LZ8zuw8USpPhf+5QhzvRvDxERO0ZlvYej+V+nucJHw2xva4OFkpmujgJ4NnFa6
         hjfM6/7rIouH8aOeeC5n3l1cZhxz8NVdT9ikdGKXxrMR/STc1Qk1isVwBlNXIeu40N
         O6G0yLyAMWSbgE+mg7kuGh4VoZ+UBUMwnD47rkm8=
To:     <netdev@vger.kernel.org>
From:   =?UTF-8?B?0JzRg9GA0LDQstGM0LXQsiDQkNC70LXQutGB0LDQvdC00YA=?= 
        <amuravyev@s-terra.ru>
Message-ID: <6f07cd87-9c0e-57ca-e49c-22d9136553d3@s-terra.ru>
Date:   Mon, 20 Dec 2021 11:41:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: EMX.sterracsp.s-terra.com (10.0.0.10) To
 EMX.sterracsp.s-terra.com (10.0.0.10)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

         auth 852d5422 subscribe netdev \
         amuravyev@s-terra.ru

