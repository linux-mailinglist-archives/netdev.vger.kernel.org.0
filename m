Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B972A232869
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgG2Xyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:54:40 -0400
Received: from mail.loongson.cn ([114.242.206.163]:54326 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727072AbgG2Xyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 19:54:40 -0400
Received: from [10.130.0.75] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx+MUmDCJf0kQCAA--.211S3;
        Thu, 30 Jul 2020 07:54:15 +0800 (CST)
Subject: Re: [PATCH bpf-next v2] Documentation/bpf: Use valid and new links in
 index.rst
To:     Song Liu <song@kernel.org>
References: <1596028555-32028-1-git-send-email-yangtiezhu@loongson.cn>
 <CAPhsuW5CYF+iiXL8mcLTerFxhUG2i1sTB8+qoFnZRT3K0XXb4w@mail.gmail.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Tobin C. Harding" <me@tobin.cc>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <47f0bdaf-4c43-05be-3c94-3b5134402e2f@loongson.cn>
Date:   Thu, 30 Jul 2020 07:54:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5CYF+iiXL8mcLTerFxhUG2i1sTB8+qoFnZRT3K0XXb4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Dx+MUmDCJf0kQCAA--.211S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFWkGw1DAFyrJw1UCFWUtwb_yoW8Zr43pF
        4rGa1SkFs5tF43Xa97tF47Arya9ayfWF48ua4DJw1rZrn8XF109r1Sgrs0g3W2vryFvFWr
        Za4SqF90qr1ku3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvEb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xK
        xwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI
        42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
        evJa73UjIFyTuYvjxU2jXdUUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/30/2020 05:06 AM, Song Liu wrote:
> On Wed, Jul 29, 2020 at 6:17 AM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>> There exists an error "404 Not Found" when I click the html link of
>> "Documentation/networking/filter.rst" in the BPF documentation [1],
>> fix it.
>>
>> Additionally, use the new links about "BPF and XDP Reference Guide"
>> and "bpf(2)" to avoid redirects.
>>
>> [1] https://www.kernel.org/doc/html/latest/bpf/
>>
>> Fixes: d9b9170a2653 ("docs: bpf: Rename README.rst to index.rst")
>> Fixes: cb3f0d56e153 ("docs: networking: convert filter.txt to ReST")
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> ---
>>
>> v2:
>>    - Fix a typo "clik" to "click" in the commit message, sorry for that
>>
>>   Documentation/bpf/index.rst | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
>> index 26f4bb3..1b901b4 100644
>> --- a/Documentation/bpf/index.rst
>> +++ b/Documentation/bpf/index.rst
>> @@ -68,7 +68,7 @@ Testing and debugging BPF
>>
>>
>>   .. Links:
>> -.. _Documentation/networking/filter.rst: ../networking/filter.txt
>> +.. _Documentation/networking/filter.rst: ../networking/filter.html
> This should be filter.rst, no?

Hi Song,

Thanks for your reply.

I use filter.rst first, but it still appears "404 not found" when I click
this link after "make htmldocs", so I use filter.html finally.

Am I missing something? Is the test method OK?
Please correct me if I am wrong.

Thanks,
Tiezhu

>
>>   .. _man-pages: https://www.kernel.org/doc/man-pages/
>> -.. _bpf(2): http://man7.org/linux/man-pages/man2/bpf.2.html
>> -.. _BPF and XDP Reference Guide: http://cilium.readthedocs.io/en/latest/bpf/
>> +.. _bpf(2): https://man7.org/linux/man-pages/man2/bpf.2.html
>> +.. _BPF and XDP Reference Guide: https://docs.cilium.io/en/latest/bpf/
>> --
>> 2.1.0
>>

