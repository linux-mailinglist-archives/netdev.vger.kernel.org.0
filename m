Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B3124C082
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgHTOWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:22:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:52712 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgHTOWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:22:50 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k8lSo-00045G-7k; Thu, 20 Aug 2020 16:22:46 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k8lSn-0001cp-BD; Thu, 20 Aug 2020 16:22:46 +0200
Subject: Re: [PATCH bpf] libbpf: fix map index used in error message
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200819110534.9058-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <70f9ad99-e4f7-e832-7b3c-939e0749a2e2@iogearbox.net>
Date:   Thu, 20 Aug 2020 16:22:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200819110534.9058-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25905/Thu Aug 20 15:09:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 1:05 PM, Toke Høiland-Jørgensen wrote:
> The error message emitted by bpf_object__init_user_btf_maps() was using the
> wrong section ID.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thanks!
