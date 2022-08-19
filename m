Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFE059A92F
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbiHSXH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbiHSXH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:07:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA702B775F;
        Fri, 19 Aug 2022 16:07:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70979B82969;
        Fri, 19 Aug 2022 23:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A5CC433C1;
        Fri, 19 Aug 2022 23:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660950474;
        bh=xfweD1Db7pjmMOuWXitD59Y9epaVTfjdmJG40kol4fc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cN9Q8djRRIjLcJX81J4TZLfMgTDpg0tzuqzO9gtdKcavVcePIDlwSLSc2n+RPcdJx
         ae9qqRtIUgdhn0VtqjjiyLuJLZ+yLWilssZnaZ2R0ozckIPnQUuxVXY1zsZXvke8qv
         m3xIrtuKkfTgQaQqSLM8YAa0HGCu57STPtW/bWNMT4dijdTU8S0zg+qvOZ4WNxUVD1
         ZOVD6+pkhA4QmiGi+Sgplt+RnY33zCxJR4bMJxJYVUHB4900IpDmLwUXwjT21ipL0E
         HOijaMoLvBebfH/bWeZ5POCfPJNWwFSwn2tOTt5ypJy0xNNDMuHTrtxdBQPbFv0Adg
         4RgqM4czyScPg==
Date:   Fri, 19 Aug 2022 16:07:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Andrei Vagin <avagin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests: fix a couple missing .gitignore entries
Message-ID: <20220819160752.777ef64b@kernel.org>
In-Reply-To: <20220819190558.477166-1-axelrasmussen@google.com>
References: <20220819190558.477166-1-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 12:05:58 -0700 Axel Rasmussen wrote:
> Some recent commits added new test binaries, but forgot to add those to
> .gitignore. Now, after one does "make -C tools/testing/selftests", one
> ends up with some untracked files in the kernel tree.
> 
> Add the test binaries to .gitignore, to avoid this minor annoyance.
> 
> Fixes: d8b6171bd58a ("selftests/io_uring: test zerocopy send")
> Fixes: 6342140db660 ("selftests/timens: add a test for vfork+exit")
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> ---
>  tools/testing/selftests/net/.gitignore    | 3 ++-
>  tools/testing/selftests/timens/.gitignore | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index 0e5751af6247..02abf8fdfd3a 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -39,4 +39,5 @@ toeplitz
>  tun
>  cmsg_sender
>  unix_connect
> -tap
> \ No newline at end of file
> +tap
> +io_uring_zerocopy_tx

Could you make the io_uring test the first in the file?
That'd gets us closest to the alphabetical ordering (I know the file is
not ordered now, but we should start moving that way).
