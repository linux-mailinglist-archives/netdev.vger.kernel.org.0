Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110994C6E1C
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbiB1N00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbiB1N0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:26:24 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED757A99E;
        Mon, 28 Feb 2022 05:25:46 -0800 (PST)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOg21-000A8i-H2; Mon, 28 Feb 2022 14:25:41 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOg21-000XD9-63; Mon, 28 Feb 2022 14:25:41 +0100
Subject: Re: [PATCH bpf-next] bpf: add config to allow loading modules with
 BTF mismatches
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Connor O'Brien <connoro@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>
References: <20220223012814.1898677-1-connoro@google.com>
 <YhW5UIQ5kf8Fr3kI@syu-laptop.lan>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6a979467-7bfb-68eb-57d6-f5294846bac4@iogearbox.net>
Date:   Mon, 28 Feb 2022 14:25:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YhW5UIQ5kf8Fr3kI@syu-laptop.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26467/Mon Feb 28 10:24:05 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/22 5:34 AM, Shung-Hsi Yu wrote:
> On Wed, Feb 23, 2022 at 01:28:14AM +0000, Connor O'Brien wrote:
>> BTF mismatch can occur for a separately-built module even when the ABI
>> is otherwise compatible and nothing else would prevent successfully
>> loading. Add a new config to control how mismatches are handled. By
>> default, preserve the current behavior of refusing to load the
>> module. If MODULE_ALLOW_BTF_MISMATCH is enabled, load the module but
>> ignore its BTF information.
>>
>> Suggested-by: Yonghong Song <yhs@fb.com>
>> Suggested-by: Michal Suchánek <msuchanek@suse.de>
>> Signed-off-by: Connor O'Brien <connoro@google.com>
> 
> Maybe reference the discussion thread as well?
> 
> Link: https://lore.kernel.org/bpf/CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com/

LGTM, and added above into the commit log while applying. Thanks everyone!
